import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  /// Trong phiên của bé: đóng cửa sổ không thoát app.
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return !DeviceControl.shared.sessionActive
  }

  /// Trong phiên của bé: chặn Cmd+Q / Thoát. Chỉ người lớn thu hồi mới kết thúc phiên.
  override func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    return DeviceControl.shared.sessionActive ? .terminateCancel : .terminateNow
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
