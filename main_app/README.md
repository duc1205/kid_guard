# KidGuard

Ứng dụng giúp bố mẹ kiểm soát thời gian trẻ dùng điện thoại bằng câu hỏi kiến thức.

## Luồng hoạt động

1. Người lớn đưa máy cho trẻ → trẻ nhập **họ tên, ngày sinh, lớp (1–12) hoặc bậc Đại học / Sau đại học**.
2. Trẻ được dùng mọi ứng dụng trong **15 phút**.
3. Hết giờ → app tự hiện lên, trẻ phải trả lời **1 câu hỏi A/B/C/D** chọn ngẫu nhiên trong phạm vi lớp
   (các môn học + câu hỏi mở + kiến thức xã hội).
   - Đúng → thêm **5 phút**, lặp lại.
   - Sai → hiện đáp án đúng + **gợi ý phần kiến thức cần ôn**, trẻ bắt buộc bấm **OK** → **máy khoá**.
4. Chỉ người lớn nhập đúng **mật khẩu máy** mới thu hồi được → kết thúc phiên, app ngừng kiểm soát.
5. **Khu vực phụ huynh** (cần mật khẩu máy): thời gian dùng, số câu đúng/sai, chi tiết từng câu sai và
   các phần kiến thức bé hay sai của từng bé.

## Kiến trúc (Clean Architecture)

```
lib/
  core/            hằng số nghiệp vụ, theme, tiện ích, DI (composition root)
  domain/          entities, repository interfaces, use cases — Dart thuần, không phụ thuộc Flutter
  data/            datasources (SharedPreferences, assets câu hỏi, MethodChannel, local_auth),
                   mappers JSON, repository implementations
  presentation/    controllers (ChangeNotifier) + screens + widgets
assets/questions/  ngân hàng câu hỏi grade_1.json … grade_12.json, grade_13.json (Đại học), grade_14.json (Sau đại học)
android/.../kotlin SessionGuardService (đồng hồ chạy nền + giữ app luôn ở trên khi khoá),
                   BootReceiver, KidGuardAdminReceiver (tuỳ chọn Device Owner)
```

## Chạy

```bash
fvm flutter pub get
fvm flutter run
fvm flutter test
```

Trên máy Android, ở màn hình chính hãy cấp các quyền được liệt kê (**Hiển thị trên ứng dụng khác**,
**Thông báo**, **Không giới hạn pin**) và đảm bảo máy đã cài **mật khẩu màn hình khoá**.
App tự nhận diện hãng (Xiaomi, Oppo/Realme/OnePlus, Vivo/iQOO, Samsung, Huawei/Honor) để hiện thêm
các mục riêng (Tự khởi động, Bật lên khi chạy nền) và hướng dẫn từng bước cho hãng đó.

Tuỳ chọn khoá cứng (chặn cả thanh điều hướng) trên máy dành riêng cho trẻ — cần máy chưa đăng nhập tài khoản nào:

```bash
adb shell dpm set-device-owner com.pham.kidguard/.KidGuardAdminReceiver
```

## Nền tảng

| Nền tảng | Cách khoá | Build |
|---|---|---|
| Android | Foreground service đưa app lên khi hết giờ, kéo lại nếu bé thoát; tuỳ chọn Device Owner (khoá cứng) | `fvm flutter build apk --release --split-per-abi` |
| iOS 16+ | Screen Time API: extension `KidGuardMonitor` bật lá chắn chặn các app đã chọn khi hết giờ; `KidGuardShield` là giao diện lá chắn | `fvm flutter build ios` (cần ký số, xem dưới) |
| macOS | Kiosk toàn màn hình (ẩn Dock/menu, chặn Cmd+Tab, Buộc thoát), không cho thoát app trong phiên, tự mở khi đăng nhập | `fvm flutter build macos` |
| Windows | Cửa sổ toàn màn hình luôn trên cùng, chặn phím Windows/Alt+Tab/Alt+F4/Ctrl+Esc, không cho đóng trong phiên, tự chạy khi đăng nhập. Không chặn được Ctrl+Alt+Del | `flutter build windows` — **phải build trên máy Windows** |

Code native: `android/app/src/main/kotlin/…`, `ios/Runner/DeviceControl.swift` + `ios/Shared`, `ios/KidGuardMonitor`, `ios/KidGuardShield`,
`macos/Runner/DeviceControl.swift`, `windows/runner/device_control.{h,cpp}` — cùng channel `kidguard/device_control`.

### iOS: Family Controls

1. Mở `ios/Runner.xcworkspace` bằng Xcode, chọn Team cho 3 target `Runner`, `KidGuardMonitor`, `KidGuardShield`
   (Signing & Capabilities). Xcode tự tạo App ID, App Group `group.com.pham.kidguard` và capability Family Controls.
2. Chạy trên **iPhone thật** (Screen Time không chạy trên Simulator). Bản Development dùng được ngay.
3. Muốn phát hành TestFlight/App Store: gửi yêu cầu **Family Controls (Distribution)** tại
   developer.apple.com/contact/request/family-controls-distribution cho cả 3 bundle id
   (`com.pham.kidguard`, `.monitor`, `.shield`) và chờ Apple duyệt.

### Windows

Cài Visual Studio 2022 (workload "Desktop development with C++") và Flutter, sau đó:
```bat
flutter pub get
flutter build windows --release
```
File chạy: `build\windows\x64\runner\Release\KidGuard.exe`. Máy cần bật Windows Hello (PIN) để người lớn mở khoá.

## Ngôn ngữ

App tự theo ngôn ngữ của máy: **tiếng Việt** nếu máy dùng tiếng Việt, các ngôn ngữ khác dùng **tiếng Anh**.

- Chuỗi giao diện: `lib/l10n/app_en.arb` (bản gốc) và `lib/l10n/app_vi.arb`. Sửa xong chạy `fvm flutter gen-l10n`
  (hoặc chỉ cần `fvm flutter run`, code tự sinh lại).
- Thêm ngôn ngữ mới: tạo `lib/l10n/app_<mã>.arb` với đủ các key như `app_en.arb` — app tự nhận.
- Chuỗi native Android (thông báo đếm giờ): `android/app/src/main/res/values*/strings.xml`.
- Nội dung câu hỏi theo chương trình GDPT Việt Nam nên giữ tiếng Việt ở mọi ngôn ngữ.
