import Cocoa
import FlutterMacOS
import ServiceManagement

/// Điều khiển thiết bị trên macOS cho KidGuard (channel "kidguard/device_control").
///
/// - Hết giờ: hẹn giờ native đưa app lên trước và bật chế độ kiosk, kể cả khi app đang ẩn.
/// - Kiosk: toàn màn hình, ẩn Dock + thanh menu, chặn Cmd+Tab, Buộc thoát, Đăng xuất.
///   Nếu app bị mất focus thì kéo lại ngay (watchdog).
/// - Trong phiên: không cho thoát app / đóng cửa sổ; tự mở lại khi đăng nhập (macOS 13+).
final class DeviceControl: NSObject, NSWindowDelegate {
  static let shared = DeviceControl()

  private weak var window: NSWindow?
  private var channel: FlutterMethodChannel?
  private var deadlineTimer: Timer?
  private var watchdog: Timer?
  private var napActivity: NSObjectProtocol?
  private var savedFrame: NSRect?
  private var savedLevel: NSWindow.Level = .normal

  private let defaults = UserDefaults.standard
  private enum Key {
    static let active = "kg.native.active"
    static let deadline = "kg.native.deadline"
    static let guardOn = "kg.native.guard"
    static let relaunch = "kg.native.relaunchAfterLogin"
  }

  /// Phụ huynh đã đồng ý cho KidGuard tự mở lại sau khi đăng nhập trong phiên
  /// (App Store 2.4.5: không tự chạy lúc đăng nhập khi chưa có đồng ý).
  private var relaunchAllowed: Bool {
    get { defaults.bool(forKey: Key.relaunch) }
    set { defaults.set(newValue, forKey: Key.relaunch) }
  }

  /// Đang có phiên (từ lúc bé bắt đầu tới khi người lớn thu hồi).
  private(set) var sessionActive: Bool {
    get { defaults.bool(forKey: Key.active) }
    set { defaults.set(newValue, forKey: Key.active) }
  }
  private var deadline: Double {
    get { defaults.double(forKey: Key.deadline) }
    set { defaults.set(newValue, forKey: Key.deadline) }
  }
  private var guardOn: Bool {
    get { defaults.bool(forKey: Key.guardOn) }
    set { defaults.set(newValue, forKey: Key.guardOn) }
  }
  private var suspended = false

  func attach(window: NSWindow, messenger: FlutterBinaryMessenger) {
    self.window = window
    window.delegate = self
    let channel = FlutterMethodChannel(name: "kidguard/device_control", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    self.channel = channel

    // Khôi phục phiên sau khi app được mở lại (đăng nhập lại, mở lại bằng tay…).
    if sessionActive {
      beginNapGuard()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        guard let self else { return }
        if self.guardOn || Date().timeIntervalSince1970 * 1000 >= self.deadline {
          self.guardOn = true
          self.applyGuard()
        } else {
          self.scheduleDeadline()
        }
      }
    }
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any]
    switch call.method {
    case "startTimer":
      deadline = (args?["endsAtMillis"] as? NSNumber)?.doubleValue ?? 0
      sessionActive = true
      guardOn = false
      beginNapGuard()
      setLaunchAtLogin(relaunchAllowed)
      scheduleDeadline()
      applyGuard()
      result(nil)
    case "setGuard":
      guardOn = (args?["enabled"] as? Bool) ?? false
      suspended = false
      applyGuard()
      result(nil)
    case "suspendGuard":
      // Hộp thoại mật khẩu / Touch ID của hệ thống phải hiện được phía trên.
      suspended = (args?["suspended"] as? Bool) ?? false
      applyGuard()
      result(nil)
    case "stop":
      sessionActive = false
      guardOn = false
      suspended = false
      deadlineTimer?.invalidate()
      deadlineTimer = nil
      applyGuard()
      endNapGuard()
      setLaunchAtLogin(false)
      result(nil)
    case "moveToBackground":
      NSApp.hide(nil)
      result(nil)
    case "setRelaunchAfterLogin":
      relaunchAllowed = (args?["allowed"] as? Bool) ?? false
      setLaunchAtLogin(relaunchAllowed && sessionActive)
      result(nil)
    case "permissionStatus":
      result([
        "overlay": true,
        "notifications": true,
        "deviceOwner": false,
        "batteryUnrestricted": true,
        "manufacturer": "apple",
      ])
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Hẹn giờ

  private func scheduleDeadline() {
    deadlineTimer?.invalidate()
    let fireAt = Date(timeIntervalSince1970: deadline / 1000)
    let timer = Timer(fire: fireAt, interval: 0, repeats: false) { [weak self] _ in
      guard let self, self.sessionActive else { return }
      self.guardOn = true
      self.applyGuard()
    }
    RunLoop.main.add(timer, forMode: .common)
    deadlineTimer = timer
  }

  /// Ngăn App Nap làm trễ đồng hồ khi app bị ẩn.
  private func beginNapGuard() {
    guard napActivity == nil else { return }
    napActivity = ProcessInfo.processInfo.beginActivity(
      options: [.userInitiatedAllowingIdleSystemSleep],
      reason: "KidGuard screen-time session")
  }

  private func endNapGuard() {
    if let a = napActivity { ProcessInfo.processInfo.endActivity(a) }
    napActivity = nil
  }

  // MARK: - Kiosk

  private func applyGuard() {
    let locked = sessionActive && guardOn && !suspended
    window?.standardWindowButton(.closeButton)?.isEnabled = !sessionActive
    if locked { enterKiosk() } else { exitKiosk() }
  }

  private func enterKiosk() {
    guard let window else { return }
    NSApp.unhide(nil)
    NSApp.activate(ignoringOtherApps: true)
    if savedFrame == nil {
      savedFrame = window.frame
      savedLevel = window.level
    }
    NSApp.presentationOptions = [
      .hideDock, .hideMenuBar, .disableProcessSwitching, .disableForceQuit,
      .disableSessionTermination, .disableHideApplication, .disableAppleMenu,
    ]
    if let screen = window.screen ?? NSScreen.main {
      window.setFrame(screen.frame, display: true)
    }
    window.level = .mainMenu + 1
    window.makeKeyAndOrderFront(nil)

    if watchdog == nil {
      let t = Timer(timeInterval: 0.7, repeats: true) { [weak self] _ in
        guard let self, let w = self.window else { return }
        if !NSApp.isActive || !w.isKeyWindow || w.isMiniaturized {
          NSApp.unhide(nil)
          w.deminiaturize(nil)
          NSApp.activate(ignoringOtherApps: true)
          w.makeKeyAndOrderFront(nil)
        }
      }
      RunLoop.main.add(t, forMode: .common)
      watchdog = t
    }
  }

  private func exitKiosk() {
    watchdog?.invalidate()
    watchdog = nil
    guard savedFrame != nil || !NSApp.presentationOptions.isEmpty else { return }
    NSApp.presentationOptions = []
    if let window {
      window.level = savedLevel
      if let frame = savedFrame { window.setFrame(frame, display: true, animate: true) }
    }
    savedFrame = nil
  }

  // MARK: - Tự mở khi đăng nhập

  private func setLaunchAtLogin(_ enabled: Bool) {
    if #available(macOS 13.0, *) {
      do {
        if enabled {
          if SMAppService.mainApp.status != .enabled { try SMAppService.mainApp.register() }
        } else if SMAppService.mainApp.status == .enabled {
          try SMAppService.mainApp.unregister()
        }
      } catch {
        NSLog("KidGuard: launch-at-login error \(error)")
      }
    }
  }

  // MARK: - NSWindowDelegate

  func windowShouldClose(_ sender: NSWindow) -> Bool { !sessionActive }
}
