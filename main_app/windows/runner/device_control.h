#ifndef RUNNER_DEVICE_CONTROL_H_
#define RUNNER_DEVICE_CONTROL_H_

#include <flutter/binary_messenger.h>
#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <windows.h>

#include <cstdint>
#include <memory>
#include <optional>

// Điều khiển thiết bị trên Windows cho KidGuard (channel "kidguard/device_control").
//
// - Hết giờ: hẹn giờ native đưa cửa sổ lên trước và bật chế độ khoá.
// - Khoá: cửa sổ không viền, phủ kín màn hình, luôn trên cùng; hook bàn phím chặn
//   phím Windows, Alt+Tab, Alt+Esc, Alt+F4, Ctrl+Esc, Ctrl+Shift+Esc; mất focus thì kéo lại.
//   (Windows không cho ứng dụng chặn Ctrl+Alt+Del.)
// - Trong phiên: không cho đóng cửa sổ; tự chạy khi đăng nhập (HKCU\...\Run).
class DeviceControl {
 public:
  DeviceControl(flutter::BinaryMessenger* messenger, HWND hwnd);
  ~DeviceControl();

  // Xử lý message của cửa sổ chính; trả về giá trị nếu đã xử lý.
  std::optional<LRESULT> HandleMessage(HWND hwnd, UINT message, WPARAM wparam,
                                       LPARAM lparam);

 private:
  using Value = flutter::EncodableValue;

  void HandleMethodCall(const flutter::MethodCall<Value>& call,
                        std::unique_ptr<flutter::MethodResult<Value>> result);
  void ApplyGuard();
  void EnterKiosk();
  void ExitKiosk();
  void BringToFront();
  void ScheduleDeadline();
  void SetAutoStart(bool enabled);
  void Persist();
  void Restore();

  static LRESULT CALLBACK KeyboardProc(int code, WPARAM wparam, LPARAM lparam);

  HWND hwnd_;
  std::unique_ptr<flutter::MethodChannel<Value>> channel_;
  bool active_ = false;
  bool guard_ = false;
  bool suspended_ = false;
  bool kiosk_ = false;
  int64_t deadline_ms_ = 0;
  LONG_PTR saved_style_ = 0;
  WINDOWPLACEMENT saved_placement_{};

  static HHOOK keyboard_hook_;
};

#endif  // RUNNER_DEVICE_CONTROL_H_
