import '../../domain/entities/active_session.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/local_store.dart';
import '../models/json_mappers.dart';

/// Phiên đang chạy chỉ là 1 bản ghi nhỏ (<2 KB) → để trong SharedPreferences
/// cho đọc nhanh lúc mở app, tách khỏi CSDL lịch sử.
class PrefsActiveSessionRepository implements ActiveSessionRepository {
  PrefsActiveSessionRepository(this._store);
  final LocalStore _store;

  @override
  Future<ActiveSession?> get() async {
    final j = await _store.readObject(LocalStore.activeSessionKey);
    return j == null ? null : ActiveSessionMapper.fromJson(j);
  }

  @override
  Future<void> save(ActiveSession session) => _store.writeObject(
    LocalStore.activeSessionKey,
    ActiveSessionMapper.toJson(session),
  );

  @override
  Future<void> clear() => _store.remove(LocalStore.activeSessionKey);
}

class PrefsSetupChecklistRepository implements SetupChecklistRepository {
  PrefsSetupChecklistRepository(this._store);
  final LocalStore _store;

  static const keys = ['autostart', 'background_popup', 'recents_lock'];
  static String _k(String key) => 'kg.setup.$key';

  @override
  Future<Set<String>> getConfirmed() async => {
    for (final k in keys)
      if (await _store.readBool(_k(k))) k,
  };

  @override
  Future<void> setConfirmed(String key, bool confirmed) =>
      _store.writeBool(_k(key), confirmed);
}
