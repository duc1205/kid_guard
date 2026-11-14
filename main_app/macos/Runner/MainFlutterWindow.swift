import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController
    // Giao diện thiết kế dạng dọc như điện thoại.
    self.setContentSize(NSSize(width: 480, height: 860))
    self.contentMinSize = NSSize(width: 400, height: 640)
    self.center()
    self.title = "KidGuard"

    RegisterGeneratedPlugins(registry: flutterViewController)
    DeviceControl.shared.attach(
      window: self, messenger: flutterViewController.engine.binaryMessenger)

    super.awakeFromNib()
  }
}
