import 'dart:typed_data';

import '../entities/valued_item.dart';

abstract class ValuationRepository {
  Future<ValuationResult> valueFromImage({
    required Uint8List jpegBytes,
    List<String> detectionHints = const [],
  });
}

abstract class HistoryRepository {
  Future<List<ScanHistoryEntry>> getAll();
  Future<void> add(ScanHistoryEntry entry);
  Future<void> remove(String id);
  Future<void> clear();
}
