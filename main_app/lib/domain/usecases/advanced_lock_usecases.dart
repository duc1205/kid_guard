import '../repositories/repositories.dart';

enum AdvancedLockStatus {
  /// Đang bật (Trợ năng của KidGuard có trong danh sách dịch vụ của hệ thống).
  on,

  /// Chưa từng bật, hoặc phụ huynh đã chọn không dùng nữa.
  off,

  /// Từng bật nhưng giờ tắt. Android tự gỡ dịch vụ Trợ năng khi app bị buộc
  /// dừng (Cài đặt › Buộc dừng, dọn đa nhiệm trên một số máy, cài đè bản mới)
  /// và không cho app tự bật lại → phải báo phụ huynh bật lại.
  droppedBySystem,
}

/// Theo dõi Khoá nâng cao (Android) để phát hiện lúc hệ thống tự tắt nó.
class CheckAdvancedLockUseCase {
  CheckAdvancedLockUseCase(this._memory);

  final AdvancedLockMemoryRepository _memory;

  Future<AdvancedLockStatus> call(DevicePermissions perms) async {
    if (perms.platform != DevicePlatform.android) return AdvancedLockStatus.off;
    final seenOn = await _memory.wasSeenOn();
    if (perms.accessibility) {
      if (!seenOn) await _memory.setSeenOn(true);
      return AdvancedLockStatus.on;
    }
    return seenOn ? AdvancedLockStatus.droppedBySystem : AdvancedLockStatus.off;
  }

  /// Phụ huynh chủ động không dùng Khoá nâng cao nữa → thôi cảnh báo.
  Future<void> forget() => _memory.setSeenOn(false);
}
