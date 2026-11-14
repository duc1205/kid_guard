import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Lưu JSON nhỏ trên máy (SharedPreferences) — hiện chỉ dùng cho phiên đang chạy.
class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferencesAsync _prefs;

  static const activeSessionKey = 'kg.active_session';

  /// Khoá của bản cũ (trước khi chuyển sang SQLite) — chỉ dùng để migrate.
  static const legacyChildrenKey = 'kg.children';
  static const legacyLogsKey = 'kg.logs';

  Future<List<Map<String, dynamic>>> readList(String key) async {
    final raw = await _prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    return (jsonDecode(raw) as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<void> writeList(String key, List<Map<String, dynamic>> value) =>
      _prefs.setString(key, jsonEncode(value));

  Future<Map<String, dynamic>?> readObject(String key) async {
    final raw = await _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<void> writeObject(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  Future<bool> readBool(String key) async =>
      (await _prefs.getBool(key)) ?? false;

  Future<void> writeBool(String key, bool value) => _prefs.setBool(key, value);

  Future<int?> readInt(String key) => _prefs.getInt(key);

  Future<void> writeInt(String key, int value) => _prefs.setInt(key, value);

  Future<void> remove(String key) => _prefs.remove(key);
}
