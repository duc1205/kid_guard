import 'package:shared_preferences/shared_preferences.dart';

class ApiKeyStore {
  static const prefsKey = 'gemini_api_key';
  static const dartDefineKey = 'GEMINI_API_KEY';

  static Future<String?> read() async {
    const fromEnv = String.fromEnvironment(dartDefineKey, defaultValue: '');
    if (fromEnv.isNotEmpty) return fromEnv;
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(prefsKey)?.trim();
    if (saved == null || saved.isEmpty) return null;
    return saved;
  }

  static Future<void> save(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefsKey, key.trim());
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefsKey);
  }

  static bool get hasDartDefine {
    const fromEnv = String.fromEnvironment(dartDefineKey, defaultValue: '');
    return fromEnv.isNotEmpty;
  }
}
