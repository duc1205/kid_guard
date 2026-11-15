import DeviceActivity
import FamilyControls
import Flutter
import ManagedSettings
import SwiftUI
import UIKit

/// Điều khiển thiết bị trên iOS cho KidGuard (channel "kidguard/device_control"),
/// dùng Screen Time API (FamilyControls + ManagedSettings + DeviceActivity).
///
/// Cấp quyền Screen Time: ưu tiên [FamilyControlsMember.child] (Apple ID trẻ em
/// trong Family Sharing — bé khó vượt). App Flutter có thể gọi lại với
/// `.individual` khi phụ huynh cho bé mượn iPhone của mình (bé có thể xoá app).
///
/// - startTimer: gỡ lá chắn, lên lịch DeviceActivity kết thúc đúng lúc hết giờ →
///   extension KidGuardMonitor bật lá chắn chặn các app đã chọn (kể cả khi KidGuard đang tắt).
/// - setGuard(true/false): bật/gỡ lá chắn ngay (khi KidGuard đang mở).
/// - stop: gỡ lá chắn, dừng theo dõi.
final class DeviceControl: NSObject {
  static let shared = DeviceControl()
  private var channel: FlutterMethodChannel?

  func attach(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "kidguard/device_control", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    self.channel = channel
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any]
    switch call.method {
    case "permissionStatus":
      result([
        "overlay": true,
        "notifications": true,
        "deviceOwner": false,
        "batteryUnrestricted": true,
        "manufacturer": "apple",
        "screenTimeAuthorized": AuthorizationCenter.shared.authorizationStatus == .approved,
        "limitedAppsSelected": KidGuardShared.hasSelection(),
      ])
    case "requestScreenTimeAuthorization":
      let mode = (args?["mode"] as? String) ?? "child"
      let member: FamilyControlsMember = mode == "individual" ? .individual : .child
      Task { @MainActor in
        do {
          try await AuthorizationCenter.shared.requestAuthorization(for: member)
          let ok = AuthorizationCenter.shared.authorizationStatus == .approved
          result([
            "approved": ok,
            "mode": mode,
            "errorCode": ok ? NSNull() : "denied",
          ] as [String: Any])
        } catch let error as FamilyControlsError {
          NSLog("KidGuard: Screen Time authorization failed (\(mode)): \(error)")
          result([
            "approved": false,
            "mode": mode,
            "errorCode": Self.screenTimeErrorCode(error),
          ] as [String: Any])
        } catch {
          NSLog("KidGuard: Screen Time authorization failed (\(mode)): \(error)")
          result([
            "approved": false,
            "mode": mode,
            "errorCode": "failed",
          ] as [String: Any])
        }
      }
    case "chooseLimitedApps":
      presentPicker(result: result)
    case "startTimer":
      let endsAt = Date(
        timeIntervalSince1970: ((args?["endsAtMillis"] as? NSNumber)?.doubleValue ?? 0) / 1000)
      KidGuardShared.clearShield()
      scheduleMonitoring(endsAt: endsAt)
      result(nil)
    case "setGuard":
      if (args?["enabled"] as? Bool) == true {
        KidGuardShared.applyShield()
      } else {
        KidGuardShared.clearShield()
      }
      result(nil)
    case "stop":
      DeviceActivityCenter().stopMonitoring([KidGuardShared.activity])
      KidGuardShared.clearShield()
      result(nil)
    case "suspendGuard", "moveToBackground":
      result(nil)  // iOS: hộp thoại Face ID luôn hiện được; app không thể tự xuống nền.
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// DeviceActivity yêu cầu khoảng theo dõi tối thiểu 15 phút, nên khoảng luôn được
  /// đặt là [hết giờ − 15 phút, hết giờ]; extension bật lá chắn khi khoảng kết thúc.
  private func scheduleMonitoring(endsAt: Date) {
    let center = DeviceActivityCenter()
    center.stopMonitoring([KidGuardShared.activity])
    let start = endsAt.addingTimeInterval(-15 * 60)
    let comps: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
    let schedule = DeviceActivitySchedule(
      intervalStart: Calendar.current.dateComponents(comps, from: start),
      intervalEnd: Calendar.current.dateComponents(comps, from: endsAt),
      repeats: false)
    do {
      try center.startMonitoring(KidGuardShared.activity, during: schedule)
    } catch {
      NSLog("KidGuard: startMonitoring failed: \(error)")
    }
  }

  /// Mã lỗi gọn cho Dart (l10n). Map theo tên case để khỏi phụ thuộc SDK.
  private static func screenTimeErrorCode(_ error: FamilyControlsError) -> String {
    let name = String(describing: error).lowercased()
    if name.contains("cancel") { return "cancelled" }
    if name.contains("unavailable") { return "unavailable" }
    // Xin `.child` trên máy không phải tài khoản trẻ em / Family Sharing thường ra restricted.
    if name.contains("restricted") { return "restricted" }
    // Đã có app kiểm soát phụ huynh khác giữ quyền Screen Time trên máy.
    if name.contains("conflict") { return "conflict" }
    if name.contains("invalid") || name.contains("account") {
      return "invalidAccount"
    }
    return "failed"
  }

  private func presentPicker(result: @escaping FlutterResult) {
    guard let root = UIApplication.shared.connectedScenes
      .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController }).first
    else {
      result(false)
      return
    }
    var host: UIViewController?
    let picker = AppPickerView(selection: KidGuardShared.loadSelection()) { selection in
      if let selection { KidGuardShared.saveSelection(selection) }
      host?.dismiss(animated: true)
      result(KidGuardShared.hasSelection())
    }
    let vc = UIHostingController(rootView: picker)
    host = vc
    root.present(vc, animated: true)
  }
}

/// Bảng chọn ứng dụng của Apple (người lớn chọn app / nhóm app sẽ bị chặn khi hết giờ).
private struct AppPickerView: View {
  @State var selection: FamilyActivitySelection
  let onDone: (FamilyActivitySelection?) -> Void

  private var vi: Bool { Locale.preferredLanguages.first?.hasPrefix("vi") ?? false }

  var body: some View {
    NavigationView {
      FamilyActivityPicker(selection: $selection)
        .navigationTitle(vi ? "Ứng dụng bị chặn khi hết giờ" : "Apps blocked when time is up")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button(vi ? "Huỷ" : "Cancel") { onDone(nil) }
          }
          ToolbarItem(placement: .confirmationAction) {
            Button(vi ? "Xong" : "Done") { onDone(selection) }
          }
        }
    }
  }
}
