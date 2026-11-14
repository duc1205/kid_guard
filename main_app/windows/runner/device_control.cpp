#include "device_control.h"

#include <flutter/standard_method_codec.h>

#include <chrono>
#include <string>

namespace {

constexpr UINT_PTR kDeadlineTimerId = 0x4B47;  // "KG"
constexpr UINT_PTR kWatchdogTimerId = 0x4B48;
constexpr UINT kWatchdogIntervalMs = 700;

constexpr wchar_t kStateKey[] = L"Software\\KidGuard";
constexpr wchar_t kRunKey[] =
    L"Software\\Microsoft\\Windows\\CurrentVersion\\Run";
constexpr wchar_t kRunValue[] = L"KidGuard";

int64_t NowMs() {
  using namespace std::chrono;
  return duration_cast<milliseconds>(system_clock::now().time_since_epoch())
      .count();
}

const flutter::EncodableValue* Arg(const flutter::EncodableValue* args,
                                   const char* key) {
  const auto* map = std::get_if<flutter::EncodableMap>(args);
  if (!map) return nullptr;
  auto it = map->find(flutter::EncodableValue(key));
  return it == map->end() ? nullptr : &it->second;
}

bool BoolArg(const flutter::EncodableValue* args, const char* key) {
  const auto* v = Arg(args, key);
  const auto* b = v ? std::get_if<bool>(v) : nullptr;
  return b && *b;
}

DWORD ReadDword(HKEY key, const wchar_t* name) {
  DWORD value = 0, size = sizeof(value);
  RegGetValueW(key, nullptr, name, RRF_RT_REG_DWORD, nullptr, &value, &size);
  return value;
}

}  // namespace

HHOOK DeviceControl::keyboard_hook_ = nullptr;

DeviceControl::DeviceControl(flutter::BinaryMessenger* messenger, HWND hwnd)
    : hwnd_(hwnd) {
  saved_placement_.length = sizeof(WINDOWPLACEMENT);
  channel_ = std::make_unique<flutter::MethodChannel<Value>>(
      messenger, "kidguard/device_control",
      &flutter::StandardMethodCodec::GetInstance());
  channel_->SetMethodCallHandler([this](const auto& call, auto result) {
    HandleMethodCall(call, std::move(result));
  });
  Restore();
}

DeviceControl::~DeviceControl() {
  if (keyboard_hook_) {
    UnhookWindowsHookEx(keyboard_hook_);
    keyboard_hook_ = nullptr;
  }
}

void DeviceControl::HandleMethodCall(
    const flutter::MethodCall<Value>& call,
    std::unique_ptr<flutter::MethodResult<Value>> result) {
  const std::string& method = call.method_name();
  const Value* args = call.arguments();

  if (method == "startTimer") {
    const Value* ends = Arg(args, "endsAtMillis");
    deadline_ms_ = ends ? ends->LongValue() : 0;
    active_ = true;
    guard_ = false;
    Persist();
    SetAutoStart(true);
    ScheduleDeadline();
    ApplyGuard();
    result->Success();
  } else if (method == "setGuard") {
    guard_ = BoolArg(args, "enabled");
    suspended_ = false;
    Persist();
    ApplyGuard();
    result->Success();
  } else if (method == "suspendGuard") {
    // Hộp thoại Windows Hello phải hiện được phía trên cửa sổ khoá.
    suspended_ = BoolArg(args, "suspended");
    ApplyGuard();
    result->Success();
  } else if (method == "stop") {
    active_ = false;
    guard_ = false;
    suspended_ = false;
    KillTimer(hwnd_, kDeadlineTimerId);
    Persist();
    SetAutoStart(false);
    ApplyGuard();
    result->Success();
  } else if (method == "moveToBackground") {
    ShowWindow(hwnd_, SW_MINIMIZE);
    result->Success();
  } else if (method == "permissionStatus") {
    result->Success(Value(flutter::EncodableMap{
        {Value("overlay"), Value(true)},
        {Value("notifications"), Value(true)},
        {Value("deviceOwner"), Value(false)},
        {Value("batteryUnrestricted"), Value(true)},
        {Value("manufacturer"), Value("microsoft")},
    }));
  } else {
    result->NotImplemented();
  }
}

std::optional<LRESULT> DeviceControl::HandleMessage(HWND hwnd, UINT message,
                                                    WPARAM wparam,
                                                    LPARAM lparam) {
  switch (message) {
    case WM_TIMER:
      if (wparam == kDeadlineTimerId) {
        KillTimer(hwnd_, kDeadlineTimerId);
        if (active_) {
          guard_ = true;
          Persist();
          ApplyGuard();
        }
        return 0;
      }
      if (wparam == kWatchdogTimerId) {
        if (kiosk_ && GetForegroundWindow() != hwnd_) BringToFront();
        return 0;
      }
      break;
    case WM_CLOSE:
      // Trong phiên của bé: không cho đóng (Alt+F4, nút X, Task bar).
      if (active_) return 0;
      break;
    case WM_SYSCOMMAND:
      if (kiosk_ && ((wparam & 0xFFF0) == SC_MINIMIZE ||
                     (wparam & 0xFFF0) == SC_MOVE ||
                     (wparam & 0xFFF0) == SC_SIZE)) {
        return 0;
      }
      break;
  }
  return std::nullopt;
}

void DeviceControl::ApplyGuard() {
  const bool locked = active_ && guard_ && !suspended_;
  if (locked) {
    EnterKiosk();
  } else {
    ExitKiosk();
  }
}

void DeviceControl::EnterKiosk() {
  if (!kiosk_) {
    GetWindowPlacement(hwnd_, &saved_placement_);
    saved_style_ = GetWindowLongPtr(hwnd_, GWL_STYLE);
    SetWindowLongPtr(hwnd_, GWL_STYLE,
                     (saved_style_ & ~(WS_CAPTION | WS_THICKFRAME |
                                       WS_MINIMIZEBOX | WS_MAXIMIZEBOX |
                                       WS_SYSMENU)) |
                         WS_POPUP);
    kiosk_ = true;
  }
  MONITORINFO mi{sizeof(MONITORINFO)};
  GetMonitorInfo(MonitorFromWindow(hwnd_, MONITOR_DEFAULTTOPRIMARY), &mi);
  ShowWindow(hwnd_, SW_RESTORE);
  SetWindowPos(hwnd_, HWND_TOPMOST, mi.rcMonitor.left, mi.rcMonitor.top,
               mi.rcMonitor.right - mi.rcMonitor.left,
               mi.rcMonitor.bottom - mi.rcMonitor.top,
               SWP_FRAMECHANGED | SWP_SHOWWINDOW);
  BringToFront();
  if (!keyboard_hook_) {
    keyboard_hook_ = SetWindowsHookExW(WH_KEYBOARD_LL, KeyboardProc,
                                       GetModuleHandle(nullptr), 0);
  }
  SetTimer(hwnd_, kWatchdogTimerId, kWatchdogIntervalMs, nullptr);
}

void DeviceControl::ExitKiosk() {
  KillTimer(hwnd_, kWatchdogTimerId);
  if (keyboard_hook_) {
    UnhookWindowsHookEx(keyboard_hook_);
    keyboard_hook_ = nullptr;
  }
  if (!kiosk_) return;
  kiosk_ = false;
  SetWindowLongPtr(hwnd_, GWL_STYLE, saved_style_);
  SetWindowPos(hwnd_, HWND_NOTOPMOST, 0, 0, 0, 0,
               SWP_NOMOVE | SWP_NOSIZE | SWP_FRAMECHANGED);
  SetWindowPlacement(hwnd_, &saved_placement_);
}

void DeviceControl::BringToFront() {
  if (IsIconic(hwnd_)) ShowWindow(hwnd_, SW_RESTORE);
  // Windows chặn SetForegroundWindow từ app nền; gắn tạm vào luồng đang có focus.
  HWND fg = GetForegroundWindow();
  DWORD fg_thread = fg ? GetWindowThreadProcessId(fg, nullptr) : 0;
  DWORD my_thread = GetCurrentThreadId();
  if (fg_thread && fg_thread != my_thread) {
    AttachThreadInput(fg_thread, my_thread, TRUE);
    SetForegroundWindow(hwnd_);
    BringWindowToTop(hwnd_);
    AttachThreadInput(fg_thread, my_thread, FALSE);
  } else {
    SetForegroundWindow(hwnd_);
  }
  SetFocus(hwnd_);
}

void DeviceControl::ScheduleDeadline() {
  KillTimer(hwnd_, kDeadlineTimerId);
  if (!active_ || deadline_ms_ <= 0) return;
  int64_t delay = deadline_ms_ - NowMs();
  if (delay < 0) delay = 0;
  if (delay > USER_TIMER_MAXIMUM) delay = USER_TIMER_MAXIMUM;
  SetTimer(hwnd_, kDeadlineTimerId, static_cast<UINT>(delay), nullptr);
}

LRESULT CALLBACK DeviceControl::KeyboardProc(int code, WPARAM wparam,
                                             LPARAM lparam) {
  if (code == HC_ACTION) {
    const auto* k = reinterpret_cast<KBDLLHOOKSTRUCT*>(lparam);
    const bool alt = (k->flags & LLKHF_ALTDOWN) != 0;
    const bool ctrl = (GetAsyncKeyState(VK_CONTROL) & 0x8000) != 0;
    const bool shift = (GetAsyncKeyState(VK_SHIFT) & 0x8000) != 0;
    const DWORD vk = k->vkCode;
    const bool block = vk == VK_LWIN || vk == VK_RWIN || vk == VK_APPS ||
                       (alt && (vk == VK_TAB || vk == VK_ESCAPE ||
                                vk == VK_F4 || vk == VK_SPACE)) ||
                       (ctrl && vk == VK_ESCAPE) ||
                       (ctrl && shift && vk == VK_ESCAPE);
    if (block) return 1;
  }
  return CallNextHookEx(nullptr, code, wparam, lparam);
}

void DeviceControl::SetAutoStart(bool enabled) {
  HKEY key;
  if (RegOpenKeyExW(HKEY_CURRENT_USER, kRunKey, 0, KEY_SET_VALUE, &key) !=
      ERROR_SUCCESS) {
    return;
  }
  if (enabled) {
    wchar_t path[MAX_PATH];
    DWORD len = GetModuleFileNameW(nullptr, path, MAX_PATH);
    std::wstring cmd = L"\"" + std::wstring(path, len) + L"\"";
    RegSetValueExW(key, kRunValue, 0, REG_SZ,
                   reinterpret_cast<const BYTE*>(cmd.c_str()),
                   static_cast<DWORD>((cmd.size() + 1) * sizeof(wchar_t)));
  } else {
    RegDeleteValueW(key, kRunValue);
  }
  RegCloseKey(key);
}

void DeviceControl::Persist() {
  HKEY key;
  if (RegCreateKeyExW(HKEY_CURRENT_USER, kStateKey, 0, nullptr, 0,
                      KEY_SET_VALUE, nullptr, &key, nullptr) != ERROR_SUCCESS) {
    return;
  }
  DWORD active = active_ ? 1 : 0, guard = guard_ ? 1 : 0;
  uint64_t deadline = static_cast<uint64_t>(deadline_ms_);
  RegSetValueExW(key, L"Active", 0, REG_DWORD,
                 reinterpret_cast<const BYTE*>(&active), sizeof(active));
  RegSetValueExW(key, L"Guard", 0, REG_DWORD,
                 reinterpret_cast<const BYTE*>(&guard), sizeof(guard));
  RegSetValueExW(key, L"Deadline", 0, REG_QWORD,
                 reinterpret_cast<const BYTE*>(&deadline), sizeof(deadline));
  RegCloseKey(key);
}

void DeviceControl::Restore() {
  HKEY key;
  if (RegOpenKeyExW(HKEY_CURRENT_USER, kStateKey, 0, KEY_READ, &key) !=
      ERROR_SUCCESS) {
    return;
  }
  active_ = ReadDword(key, L"Active") != 0;
  guard_ = ReadDword(key, L"Guard") != 0;
  uint64_t deadline = 0;
  DWORD size = sizeof(deadline);
  RegGetValueW(key, nullptr, L"Deadline", RRF_RT_REG_QWORD, nullptr, &deadline,
               &size);
  deadline_ms_ = static_cast<int64_t>(deadline);
  RegCloseKey(key);

  if (!active_) return;
  if (guard_ || NowMs() >= deadline_ms_) {
    guard_ = true;
    ApplyGuard();
  } else {
    ScheduleDeadline();
  }
}
