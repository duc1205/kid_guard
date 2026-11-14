import DeviceActivity
import ManagedSettings

/// Chạy bởi hệ thống (kể cả khi KidGuard đã tắt): hết khoảng thời gian được dùng
/// → bật lá chắn Screen Time chặn các app người lớn đã chọn.
class KidGuardMonitor: DeviceActivityMonitor {
  override func intervalDidEnd(for activity: DeviceActivityName) {
    super.intervalDidEnd(for: activity)
    guard activity == KidGuardShared.activity else { return }
    KidGuardShared.applyShield()
  }
}
