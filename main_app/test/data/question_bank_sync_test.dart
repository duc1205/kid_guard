import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:main_app/core/constants/app_constants.dart';
import 'package:main_app/data/datasources/app_database.dart';
import 'package:main_app/data/datasources/question_asset_datasource.dart';
import 'package:main_app/data/datasources/question_cache_datasource.dart';
import 'package:main_app/data/datasources/question_remote_datasource.dart';
import 'package:main_app/data/models/question_file_parser.dart';
import 'package:main_app/data/repositories/question_bank_repository.dart';
import 'package:main_app/domain/entities/question_bank.dart';
import 'package:main_app/domain/usecases/question_bank_usecases.dart';

import '../fakes.dart';

/// Tải câu hỏi từ internet: chỉ dùng bản mới khi hợp lệ, lỗi thì giữ bản cũ,
/// mất mạng vẫn có câu hỏi đóng gói sẵn.
void main() {
  final base = Uri.parse(AppConstants.defaultQuestionSourceUrl);
  final bundledManifest =
      jsonDecode(File('assets/questions/manifest.json').readAsStringSync())
          as Map<String, dynamic>;
  final bundledVersion = bundledManifest['version'] as int;

  String questionsJson(String prefix, {int options = 4}) => jsonEncode([
    for (var i = 0; i < 6; i++)
      {
        'id': '${prefix}_$i',
        'subject': 'Toán',
        'topic': 'Chủ đề',
        'type': 'academic',
        'question': 'Câu hỏi $prefix $i?',
        'options': ['A$i', 'B$i', 'C$i', 'D$i'].take(options).toList(),
        'answerIndex': 1,
        'suggestion': 'Ôn lại',
        'source': 'CT GDPT 2018',
      },
  ]);

  String sha(String body) => sha256.convert(utf8.encode(body)).toString();

  /// manifest = bản đóng gói + các lớp ghi đè.
  Map<String, dynamic> manifest(int version, Map<String, Object> overrides) => {
    'version': version,
    'grades': {
      ...(bundledManifest['grades'] as Map<String, dynamic>),
      ...overrides,
    },
  };

  late AppDatabase db;
  late MemoryLocalStore store;
  late Map<String, String> server;
  late List<String> requested;
  late QuestionBankRepositoryImpl repo;

  setUp(() async {
    db = await openTestDatabase();
    store = MemoryLocalStore();
    server = {};
    requested = [];
    repo = QuestionBankRepositoryImpl(
      assets: QuestionAssetDataSource(bundle: FileAssetBundle()),
      cache: QuestionCacheDataSource(db),
      remote: QuestionRemoteDataSource(
        client: MockClient((req) async {
          requested.add(req.url.toString());
          final body = server[req.url.toString()];
          return body == null
              ? http.Response('not found', 404)
              : http.Response.bytes(utf8.encode(body), 200);
        }),
      ),
      store: store,
    );
  });

  tearDown(() => db.close());

  void publish(Map<String, dynamic> m, Map<String, String> files) {
    server[base.toString()] = jsonEncode(m);
    files.forEach((name, body) => server[base.resolve(name).toString()] = body);
  }

  test('mất mạng → lỗi network, vẫn dùng bộ câu hỏi đóng gói sẵn', () async {
    final r = await repo.sync();
    expect(r.status, QuestionSyncStatus.failed);
    expect(r.error, QuestionSyncError.network);
    final qs = await repo.getQuestionsForGrade(5);
    expect(qs, isNotEmpty);
    final info = await repo.getInfo();
    expect(info.version, bundledVersion);
    expect(info.downloadedGrades, 0);
    expect(info.isDefaultSource, isTrue);
  });

  test('manifest cùng phiên bản → không tải file nào', () async {
    publish(manifest(bundledVersion, {}), {});
    final r = await repo.sync();
    expect(r.status, QuestionSyncStatus.upToDate);
    expect(requested, [base.toString()]);
    expect((await repo.getInfo()).lastSyncedAt, isNotNull);
  });

  test('phiên bản mới → chỉ tải lớp thay đổi và dùng ngay', () async {
    await repo.getQuestionsForGrade(3); // nạp sẵn vào bộ nhớ đệm
    final body = questionsJson('new3');
    publish(
      manifest(bundledVersion + 1, {
        '3': {'file': 'grade_3.json', 'sha256': sha(body)},
      }),
      {'grade_3.json': body},
    );
    final r = await repo.sync();
    expect(r.status, QuestionSyncStatus.updated);
    expect(r.version, bundledVersion + 1);
    expect(requested, hasLength(2), reason: 'manifest + grade_3 only');
    expect((await repo.getQuestionsForGrade(3)).first.id, 'new3_0');
    expect((await repo.getQuestionsForGrade(1)).first.id, startsWith('g1'));
    expect((await repo.getInfo()).downloadedGrades, 1);

    // Lần sau cùng phiên bản → không tải lại.
    requested.clear();
    expect((await repo.sync()).status, QuestionSyncStatus.upToDate);
    expect(requested, hasLength(1));
  });

  test('cùng phiên bản nhưng file đổi (quên tăng version) → vẫn tải', () async {
    final body = questionsJson('same3');
    publish(
      manifest(bundledVersion, {
        '3': {'file': 'grade_3.json', 'sha256': sha(body)},
      }),
      {'grade_3.json': body},
    );
    final r = await repo.sync();
    expect(r.status, QuestionSyncStatus.updated);
    expect((await repo.getQuestionsForGrade(3)).first.id, 'same3_0');
  });

  test('manifest cũ hơn bản đang dùng → không hạ cấp', () async {
    final v2 = questionsJson('v2');
    publish(
      manifest(bundledVersion + 1, {
        '3': {'file': 'grade_3.json', 'sha256': sha(v2)},
      }),
      {'grade_3.json': v2},
    );
    expect((await repo.sync()).status, QuestionSyncStatus.updated);

    final old = questionsJson('old3');
    publish(
      manifest(bundledVersion, {
        '3': {'file': 'grade_3.json', 'sha256': sha(old)},
      }),
      {'grade_3.json': old},
    );
    expect((await repo.sync()).status, QuestionSyncStatus.upToDate);
    expect((await repo.getQuestionsForGrade(3)).first.id, 'v2_0');
  });

  test('sai mã kiểm tra → từ chối, giữ bản cũ', () async {
    publish(
      manifest(bundledVersion + 1, {
        '3': {'file': 'grade_3.json', 'sha256': sha('khác')},
      }),
      {'grade_3.json': questionsJson('bad')},
    );
    final r = await repo.sync();
    expect(r.error, QuestionSyncError.checksumMismatch);
    expect((await repo.getQuestionsForGrade(3)).first.id, startsWith('g3'));
    expect((await repo.getInfo()).version, bundledVersion);
  });

  test(
    'file câu hỏi hỏng (thiếu đáp án) → từ chối toàn bộ đợt cập nhật',
    () async {
      final good = questionsJson('ok2');
      final bad = questionsJson('bad3', options: 3);
      publish(
        manifest(bundledVersion + 1, {
          '2': {'file': 'grade_2.json', 'sha256': sha(good)},
          '3': {'file': 'grade_3.json', 'sha256': sha(bad)},
        }),
        {'grade_2.json': good, 'grade_3.json': bad},
      );
      final r = await repo.sync();
      expect(r.error, QuestionSyncError.invalidQuestions);
      expect((await repo.getQuestionsForGrade(2)).first.id, startsWith('g2'));
      expect((await repo.getInfo()).downloadedGrades, 0);
    },
  );

  test('manifest sai định dạng', () async {
    server[base.toString()] = '{"version": "x"}';
    expect((await repo.sync()).error, QuestionSyncError.invalidManifest);
  });

  test(
    'nguồn tuỳ chỉnh: tải lần đầu, đổi về mặc định thì xoá bản đã tải',
    () async {
      final custom = Uri.parse(
        'https://truong.example.edu.vn/kg/manifest.json',
      );
      final body = questionsJson('school');
      server[custom.toString()] = jsonEncode({
        'version': 1,
        'grades': {
          '13': {'file': 'dh.json', 'sha256': sha(body)},
        },
      });
      server[custom.resolve('dh.json').toString()] = body;

      final change = ChangeQuestionSourceUseCase(repo);
      final r = await change(custom.toString());
      expect(r.status, QuestionSyncStatus.updated);
      var info = await repo.getInfo();
      expect(info.isDefaultSource, isFalse);
      expect(info.sourceUrl, custom.toString());
      expect((await repo.getQuestionsForGrade(13)).first.id, 'school_0');

      await change(null);
      info = await repo.getInfo();
      expect(info.isDefaultSource, isTrue);
      expect(info.downloadedGrades, 0);
      expect((await repo.getQuestionsForGrade(13)).first.id, startsWith('dh_'));
    },
  );

  test('chỉ chấp nhận địa chỉ https hợp lệ', () {
    final change = ChangeQuestionSourceUseCase(repo);
    expect(
      () => change('http://example.com/manifest.json'),
      throwsA(
        isA<QuestionSourceException>().having(
          (e) => e.error,
          'error',
          QuestionSourceError.insecureUrl,
        ),
      ),
    );
    expect(
      () => change('không phải url'),
      throwsA(isA<QuestionSourceException>()),
    );
  });

  test('SyncQuestionBankUseCase bỏ qua nếu vừa kiểm tra', () async {
    publish(manifest(bundledVersion, {}), {});
    final now = DateTime.now();
    final sync = SyncQuestionBankUseCase(repo, clock: () => now);
    expect(await sync(minInterval: const Duration(hours: 6)), isNotNull);
    expect(await sync(minInterval: const Duration(hours: 6)), isNull);
  });

  group('QuestionFileParser', () {
    test('từ chối đáp án trùng, id trùng, quá ít câu', () {
      final list = jsonDecode(questionsJson('p')) as List;
      String withChange(void Function(List l) f) {
        final copy = jsonDecode(jsonEncode(list)) as List;
        f(copy);
        return jsonEncode(copy);
      }

      expect(QuestionFileParser.parse(jsonEncode(list), 1), hasLength(6));
      expect(
        () => QuestionFileParser.parse(
          withChange((l) => l[0]['options'] = ['a', 'a', 'b', 'c']),
          1,
        ),
        throwsFormatException,
      );
      expect(
        () => QuestionFileParser.parse(
          withChange((l) => l[1]['id'] = l[0]['id']),
          1,
        ),
        throwsFormatException,
      );
      expect(
        () =>
            QuestionFileParser.parse(withChange((l) => l.removeRange(0, 3)), 1),
        throwsFormatException,
      );
      expect(
        () => QuestionFileParser.parse(
          withChange((l) => l[2]['answerIndex'] = 4),
          1,
        ),
        throwsFormatException,
      );
      expect(
        () => QuestionFileParser.parse('<html>', 1),
        throwsFormatException,
      );
    });
  });
}
