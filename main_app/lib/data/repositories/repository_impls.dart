import '../../core/constants/app_constants.dart';
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

class PrefsSettingsRepository implements SettingsRepository {
  PrefsSettingsRepository(this._store);
  final LocalStore _store;

  static const _initialAllowanceKey = 'kg.settings.initial_allowance_minutes';

  @override
  Future<Duration> getInitialAllowance() async {
    final minutes = await _store.readInt(_initialAllowanceKey);
    final d = minutes == null ? null : Duration(minutes: minutes);
    // Giá trị hỏng / dưới mức tối thiểu → dùng mặc định.
    return d == null || d < AppConstants.minInitialAllowance
        ? AppConstants.defaultInitialAllowance
        : d;
  }

  @override
  Future<void> setInitialAllowance(Duration? value) => value == null
      ? _store.remove(_initialAllowanceKey)
      : _store.writeInt(_initialAllowanceKey, value.inMinutes);
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

class PrefsAdvancedLockMemoryRepository
    implements AdvancedLockMemoryRepository {
  PrefsAdvancedLockMemoryRepository(this._store);
  final LocalStore _store;

  static const _key = 'kg.advanced_lock_seen_on';

  @override
  Future<bool> wasSeenOn() => _store.readBool(_key);

  @override
  Future<void> setSeenOn(bool seenOn) => _store.writeBool(_key, seenOn);
}

class PrefsParentConsentRepository implements ParentConsentRepository {
  PrefsParentConsentRepository(this._store);
  final LocalStore _store;

  static const _key = 'kg.parent_consent_v1';

  @override
  Future<bool> hasAccepted() => _store.readBool(_key);

  @override
  Future<void> accept() => _store.writeBool(_key, true);
}
