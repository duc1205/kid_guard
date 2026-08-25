import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/valued_item.dart';

class HistoryLocalDatasource {
  static const _key = 'scan_history_v1';

  Future<List<ScanHistoryEntry>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .whereType<Map>()
        .map((e) => ScanHistoryEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveAll(List<ScanHistoryEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}
