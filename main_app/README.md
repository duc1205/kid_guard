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
                   KidGuardAccessibilityService (Khoá nâng cao), BootReceiver,
                   KidGuardAdminReceiver (chỉ để tắt Device Owner cũ)
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

**Khoá nâng cao** (tuỳ chọn, khuyên dùng): bật Trợ năng của KidGuard ngay trên máy, không cần máy tính
(màn hình chính › Khoá nâng cao có hướng dẫn). Khi hết giờ: đóng thanh thông báo, chặn đa nhiệm / màn hình
chính / app khác; suốt phiên: chặn mở trang cài đặt, buộc dừng, gỡ cài đặt KidGuard. Trên Android 13+, APK
cài ngoài CH Play phải bật "Cho phép cài đặt hạn chế" trong Thông tin ứng dụng trước. Đưa lên CH Play cần
khai báo mục đích dùng Accessibility API (kiểm soát của phụ huynh).

Khoá cứng bằng Device Owner (adb) đã bỏ; máy nào đã bật trước đây vẫn tắt được trong màn Khoá nâng cao.

## Nền tảng

| Nền tảng | Cách khoá | Build |
|---|---|---|
| Android | Foreground service + lớp che toàn màn hình khi hết giờ, kéo lại nếu bé thoát, dừng video đang phát; tuỳ chọn Khoá nâng cao (Trợ năng) | `fvm flutter build appbundle --release` (cần keystore, xem dưới) |
| iOS 16+ | Screen Time API: extension `KidGuardMonitor` bật lá chắn chặn các app đã chọn khi hết giờ; `KidGuardShield` là giao diện lá chắn | `fvm flutter build ios` (cần ký số, xem dưới) |
| macOS | Kiosk toàn màn hình (ẩn Dock/menu, chặn Cmd+Tab, Buộc thoát), không cho thoát app trong phiên, tự mở khi đăng nhập | `fvm flutter build macos` |
| Windows | Cửa sổ toàn màn hình luôn trên cùng, chặn phím Windows/Alt+Tab/Alt+F4/Ctrl+Esc, không cho đóng trong phiên, tự chạy khi đăng nhập. Không chặn được Ctrl+Alt+Del | `flutter build windows` — **phải build trên máy Windows** |

Code native: `android/app/src/main/kotlin/…`, `ios/Runner/DeviceControl.swift` + `ios/Shared`, `ios/KidGuardMonitor`, `ios/KidGuardShield`,
`macos/Runner/DeviceControl.swift`, `windows/runner/device_control.{h,cpp}` — cùng channel `kidguard/device_control`.

### Android: ký bản phát hành (Play Store)

1. Tạo upload keystore (một lần, giữ bí mật):
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Chép `android/key.properties.example` → `android/key.properties`, điền mật khẩu và đường dẫn `storeFile`.
   File này và `*.jks` đã nằm trong `.gitignore` — không commit.
3. Chưa có `key.properties` thì `flutter build … --release` vẫn chạy (ký debug, chỉ để dev).
   Có file rồi thì bản release dùng upload key:
   ```bash
   fvm flutter build appbundle --release
   ```

### iOS: Family Controls

1. Mở `ios/Runner.xcworkspace` bằng Xcode, chọn Team cho 3 target `Runner`, `KidGuardMonitor`, `KidGuardShield`
   (Signing & Capabilities). Xcode tự tạo App ID, App Group `group.com.pham.kidguard` và capability Family Controls.
2. App xin quyền Screen Time kiểu **parental** (`AuthorizationCenter.requestAuthorization(for: .child)`):
   cài trên **iPhone của bé**, Apple ID của bé phải thuộc **Family Sharing** của phụ huynh;
   phụ huynh duyệt bằng Apple ID của mình. Bé không tự xoá app / tắt quyền để vượt lá chắn.
3. Chạy trên **iPhone thật** (Screen Time không chạy trên Simulator). Bản Development dùng được ngay.
4. Muốn phát hành TestFlight/App Store: gửi yêu cầu **Family Controls (Distribution)** tại
   developer.apple.com/contact/request/family-controls-distribution cho cả 3 bundle id
   (`com.pham.kidguard`, `.monitor`, `.shield`) và chờ Apple duyệt.
5. `ios/Shared/PrivacyInfo.xcprivacy` khai báo API lý do bắt buộc (UserDefaults, …) cho Runner + 2 extension.
   Chuỗi Face ID: `Runner/Info.plist` (tiếng Anh) và `Runner/{en,vi}.lproj/InfoPlist.strings`.

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

## Nguồn câu hỏi

- Lớp 1–12: theo Chương trình GDPT 2018 (TT 32/2018/TT-BGDĐT) đã sửa đổi theo TT 13/2022 và TT 17/2025,
  xếp chủ đề theo bộ SGK thống nhất "Kết nối tri thức với cuộc sống" (từ năm học 2026–2027).
- Đại học / Sau đại học: chương trình các học phần lý luận chính trị bắt buộc, TT 05/2020 (GDQP-AN),
  TT 53/2026 (quy chế sau đại học), Hiến pháp 2013 (sửa đổi 2025), BLDS 2015 và tài liệu học thuật chuẩn.
- Mỗi câu có trường `source` ghi căn cứ (môn – lớp – chủ đề – yêu cầu cần đạt, hoặc điều luật).
  Câu hỏi do AI soạn và đối chiếu; nên để giáo viên rà lại trước khi dùng thật.
- Khi sửa nội dung một câu, hãy đặt **id mới** (lịch sử trả lời lưu nội dung câu hỏi theo id).

### Cập nhật câu hỏi qua internet (không cần phát hành app mới)

App tải `manifest.json` từ `AppConstants.defaultQuestionSourceUrl`
(`https://raw.githubusercontent.com/duc1205/kid_guard_question/main/manifest.json`), tối đa 15 phút/lần
khi mở app, hoặc khi phụ huynh bấm **Khu vực phụ huynh › Nguồn câu hỏi › Cập nhật ngay**.

- Chỉ tải các file có mã sha256 khác bản đang có; kiểm tra mã + định dạng rồi lưu vào SQLite.
  Bất kỳ lỗi nào → giữ nguyên bản cũ. Mất mạng → dùng bản đã tải, hoặc bộ đóng gói sẵn.
- Phụ huynh có thể đổi sang nguồn khác (chỉ `https://`), ví dụ ngân hàng câu hỏi của nhà trường.

Quy trình sửa câu hỏi:

1. Sửa `assets/questions/grade_N.json` (câu sửa nội dung → id mới). Định dạng và các trường tuỳ chọn
   (`difficulty`, `term`, `status`): xem README của repo câu hỏi.
2. `fvm dart run tool/make_question_manifest.dart` → cập nhật `manifest.json`, tự tăng `version`.
   Kiểm tra chất lượng: `python3 ../../kid_guard_question/scripts/check_questions.py assets/questions`.
3. `fvm flutter test` (kiểm tra định dạng + manifest khớp file).
4. Chép `assets/questions/*.json` vào repo **công khai** [kid_guard_question](https://github.com/duc1205/kid_guard_question) rồi push.
   (Repo mã nguồn đang private nên app không đọc trực tiếp được.)
