import 'dart:typed_data';

import '../../domain/entities/valued_item.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/gemini_valuation_datasource.dart';
import '../datasources/history_local_datasource.dart';

class ValuationRepositoryImpl implements ValuationRepository {
  ValuationRepositoryImpl(this._datasource);

  final GeminiValuationDatasource _datasource;

  @override
  Future<ValuationResult> valueFromImage({
    required Uint8List jpegBytes,
    List<String> detectionHints = const [],
  }) {
    return _datasource.valueFromImage(
      jpegBytes: jpegBytes,
      detectionHints: detectionHints,
    );
  }
}

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._local);

  final HistoryLocalDatasource _local;

  @override
  Future<List<ScanHistoryEntry>> getAll() => _local.load();

  @override
  Future<void> add(ScanHistoryEntry entry) async {
    final all = await _local.load();
    all.insert(0, entry);
    final trimmed = all.take(50).toList();
    await _local.saveAll(trimmed);
  }

  @override
  Future<void> remove(String id) async {
    final all = await _local.load();
    await _local.saveAll(all.where((e) => e.id != id).toList());
  }

  @override
  Future<void> clear() => _local.saveAll(const []);
}
