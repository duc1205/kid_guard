import DeviceActivity
import FamilyControls
import Flutter
import ManagedSettings
import SwiftUI
import UIKit

/// Điều khiển thiết bị trên iOS cho KidGuard (channel "kidguard/device_control"),
/// dùng Screen Time API (FamilyControls + ManagedSettings + DeviceActivity).
///
/// Cấp quyền bằng [FamilyControlsMember.child]: máy phải đăng nhập Apple ID của bé
/// trong Family Sharing; phụ huynh duyệt bằng Apple ID của mình. Bé không tự gỡ
/// quyền / xoá app để vượt lá chắn (khác với `.individual`).
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
      Task { @MainActor in
        do {
          try await AuthorizationCenter.shared.requestAuthorization(for: .child)
        } catch {
          NSLog("KidGuard: Screen Time authorization failed: \(error)")
        }
        result(AuthorizationCenter.shared.authorizationStatus == .approved)
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
