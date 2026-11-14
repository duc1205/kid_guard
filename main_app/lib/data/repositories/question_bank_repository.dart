import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/question_bank.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/local_store.dart';
import '../datasources/question_asset_datasource.dart';
import '../datasources/question_cache_datasource.dart';
import '../datasources/question_remote_datasource.dart';
import '../models/question_bank_manifest.dart';
import '../models/question_file_parser.dart';

/// Câu hỏi lấy theo thứ tự: bản đã tải từ internet (lưu trong SQLite) → bộ đóng
/// gói sẵn trong app. Nhờ vậy luôn có câu hỏi kể cả khi mất mạng hoặc trẻ tắt wifi.
///
/// Cập nhật: tải manifest.json → nếu `version` cao hơn bản đang dùng, hoặc cùng
/// `version` nhưng có file mang mã sha256 khác (sửa câu hỏi mà quên tăng version),
/// thì chỉ tải các file khác bản đang có, kiểm tra mã + định dạng, rồi ghi tất cả
/// trong 1 transaction. Manifest cũ hơn bản đang dùng → bỏ qua (không hạ cấp).
/// Bất kỳ lỗi nào → giữ nguyên bản cũ.
class QuestionBankRepositoryImpl
    implements QuestionRepository, QuestionBankRepository {
  QuestionBankRepositoryImpl({
    required QuestionAssetDataSource assets,
    required QuestionCacheDataSource cache,
    required QuestionRemoteDataSource remote,
    required LocalStore store,
    DateTime Function()? clock,
  }) : _assets = assets,
       _cache = cache,
       _remote = remote,
       _store = store,
       _clock = clock ?? DateTime.now;

  final QuestionAssetDataSource _assets;
  final QuestionCacheDataSource _cache;
  final QuestionRemoteDataSource _remote;
  final LocalStore _store;
  final DateTime Function() _clock;

  static const metaKey = 'kg.question_bank';

  final _memo = <int, List<Question>>{};
  Future<QuestionSyncResult>? _running;

  // ---------------------------------------------------------------- đọc câu hỏi

  @override
  Future<List<Question>> getQuestionsForGrade(int grade) async {
    final memo = _memo[grade];
    if (memo != null) return memo;
    final cached = await _cache.read(grade);
    if (cached != null) {
      try {
        return _memo[grade] = QuestionFileParser.parse(cached.json, grade);
      } on FormatException catch (e) {
        debugPrint('Cached questions for grade $grade invalid: $e');
      }
    }
    return _memo[grade] = QuestionFileParser.parse(
      await _assets.loadGrade(grade),
      grade,
    );
  }

  // ---------------------------------------------------------------- thông tin

  @override
  Future<QuestionBankInfo> getInfo() async {
    final meta = await _readMeta();
    return QuestionBankInfo(
      sourceUrl: meta.source ?? AppConstants.defaultQuestionSourceUrl,
      isDefaultSource: meta.source == null,
      version: await _currentVersion(meta),
      downloadedGrades: (await _cache.hashes()).length,
      lastSyncedAt: meta.syncedAt,
    );
  }

  @override
  Future<void> setSource(String? manifestUrl) async {
    final source =
        manifestUrl == null ||
            manifestUrl == AppConstants.defaultQuestionSourceUrl
        ? null
        : manifestUrl;
    await _running?.catchError((_) => const QuestionSyncResult.upToDate(0));
    await _cache.clear();
    _memo.clear();
    await _writeMeta(_Meta(source: source, version: 0));
  }

  // ---------------------------------------------------------------- cập nhật

  @override
  Future<QuestionSyncResult> sync() =>
      _running ??= _sync().whenComplete(() => _running = null);

  Future<QuestionSyncResult> _sync() async {
    final meta = await _readMeta();
    final manifestUri = Uri.parse(
      meta.source ?? AppConstants.defaultQuestionSourceUrl,
    );

    final QuestionBankManifest manifest;
    try {
      final bytes = await _remote.fetch(manifestUri);
      manifest = QuestionBankManifest.fromJson(jsonDecode(_decode(bytes)));
    } on FormatException {
      return const QuestionSyncResult.failed(QuestionSyncError.invalidManifest);
    } catch (e) {
      debugPrint('Question manifest download failed: $e');
      return const QuestionSyncResult.failed(QuestionSyncError.network);
    }

    final current = await _currentVersion(meta);
    final have = {
      if (meta.source == null) ...await _bundledHashes(),
      ...await _cache.hashes(),
    };
    final filesChanged = manifest.grades.entries.any(
      (e) => have[e.key] != e.value.sha256,
    );
    if (manifest.version < current ||
        (manifest.version == current && !filesChanged)) {
      await _writeMeta(meta.copyWith(syncedAt: _clock()));
      return QuestionSyncResult.upToDate(current);
    }
    final pending = <int, CachedQuestionFile>{};
    for (final MapEntry(key: grade, value: entry) in manifest.grades.entries) {
      if (have[grade] == entry.sha256) continue;
      final List<int> bytes;
      try {
        bytes = await _remote.fetch(manifestUri.resolve(entry.file));
      } catch (e) {
        debugPrint('Question file download failed: $e');
        return const QuestionSyncResult.failed(QuestionSyncError.network);
      }
      final sha = sha256.convert(bytes).toString();
      if (sha != entry.sha256) {
        return const QuestionSyncResult.failed(
          QuestionSyncError.checksumMismatch,
        );
      }
      try {
        final raw = _decode(bytes);
        QuestionFileParser.parse(raw, grade);
        pending[grade] = CachedQuestionFile(sha256: sha, json: raw);
      } on FormatException catch (e) {
        debugPrint('Question file for grade $grade invalid: $e');
        return const QuestionSyncResult.failed(
          QuestionSyncError.invalidQuestions,
        );
      }
    }

    await _cache.writeAll(pending);
    pending.keys.forEach(_memo.remove);
    await _writeMeta(
      meta.copyWith(version: manifest.version, syncedAt: _clock()),
    );
    return QuestionSyncResult.updated(manifest.version);
  }

  // ---------------------------------------------------------------- tiện ích

  static String _decode(List<int> bytes) {
    final s = utf8.decode(bytes);
    return s.startsWith('﻿') ? s.substring(1) : s;
  }

  /// Phiên bản đang dùng: bản đã tải, hoặc bản đóng gói sẵn (chỉ với nguồn mặc
  /// định — nguồn tuỳ chỉnh luôn tải lần đầu).
  Future<int> _currentVersion(_Meta meta) async {
    if (meta.version > 0) return meta.version;
    if (meta.source != null) return 0;
    return (await _bundledManifest())?.version ?? 0;
  }

  Future<Map<int, String>> _bundledHashes() async => {
    for (final MapEntry(:key, :value)
        in (await _bundledManifest())?.grades.entries ??
            const <MapEntry<int, ManifestEntry>>[])
      key: value.sha256,
  };

  Future<QuestionBankManifest?> _bundledManifest() async {
    try {
      return QuestionBankManifest.fromJson(
        jsonDecode(await _assets.loadManifest()),
      );
    } catch (_) {
      return null;
    }
  }

  Future<_Meta> _readMeta() async =>
      _Meta.fromJson(await _store.readObject(metaKey));

  Future<void> _writeMeta(_Meta meta) =>
      _store.writeObject(metaKey, meta.toJson());
}

class _Meta {
  const _Meta({this.source, this.version = 0, this.syncedAt});

  /// `null` = nguồn mặc định.
  final String? source;
  final int version;
  final DateTime? syncedAt;

  factory _Meta.fromJson(Map<String, dynamic>? j) => j == null
      ? const _Meta()
      : _Meta(
          source: j['source'] as String?,
          version: (j['version'] as int?) ?? 0,
          syncedAt: j['syncedAt'] == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(j['syncedAt'] as int),
        );

  Map<String, dynamic> toJson() => {
    'source': source,
    'version': version,
    'syncedAt': syncedAt?.millisecondsSinceEpoch,
  };

  _Meta copyWith({int? version, DateTime? syncedAt}) => _Meta(
    source: source,
    version: version ?? this.version,
    syncedAt: syncedAt ?? this.syncedAt,
  );
}
