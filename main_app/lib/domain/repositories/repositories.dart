import '../entities/active_session.dart';
import '../entities/child_profile.dart';
import '../entities/question.dart';
import '../entities/question_bank.dart';
import '../entities/usage_log.dart';
import '../entities/usage_stats.dart';

abstract interface class ChildRepository {
  Future<List<ChildProfile>> getChildren();
  Future<void> saveChild(ChildProfile child);

  /// Xoá hồ sơ trẻ; sessions/attempts gắn với trẻ bị xoá theo CASCADE.
  Future<void> deleteChild(String id);

  /// Xoá mọi hồ sơ trẻ (và lịch sử gắn theo CASCADE).
  Future<void> deleteAllChildren();
}

/// Cài đặt do người lớn chọn.
abstract interface class SettingsRepository {
  /// Thời gian dùng máy ban đầu của mỗi phiên; chưa đặt → mặc định 15 phút.
  Future<Duration> getInitialAllowance();

  /// `null` = quay về mặc định.
  Future<void> setInitialAllowance(Duration? value);
}

abstract interface class QuestionRepository {
  Future<List<Question>> getQuestionsForGrade(int grade);
}

/// Ngân hàng câu hỏi tải từ internet (manifest.json + grade_N.json), lưu lại trên
/// máy để dùng khi mất mạng; chưa tải được thì dùng bộ đóng gói sẵn trong app.
abstract interface class QuestionBankRepository {
  Future<QuestionBankInfo> getInfo();

  /// Tải bản mới nếu manifest có phiên bản cao hơn. Lỗi thì giữ nguyên bản cũ.
  Future<QuestionSyncResult> sync();

  /// Đổi địa chỉ manifest; `null` = quay về nguồn mặc định. Xoá câu hỏi đã tải
  /// của nguồn cũ.
  Future<void> setSource(String? manifestUrl);
}

/// Trạng thái phiên đang diễn ra (1 bản ghi nhỏ, đọc/ghi thường xuyên).
abstract interface class ActiveSessionRepository {
  Future<ActiveSession?> get();
  Future<void> save(ActiveSession session);
  Future<void> clear();
}

/// Nhật ký sử dụng. Các thao tác ghi là tăng dần (không đọc–sửa–ghi cả lịch sử).
abstract interface class UsageLogRepository {
  Future<void> createLog(UsageLog log);
  Future<void> addUsedTime(String logId, Duration duration);
  Future<void> addAttempt(
    String logId,
    String childId,
    QuestionAttempt attempt,
  );
  Future<void> markLocked(String logId, DateTime at);
  Future<void> markEnded(String logId, DateTime at);

  /// Id các câu hỏi gần nhất đã hỏi trẻ, mới nhất trước.
  Future<List<String>> recentQuestionIds(String childId, {required int limit});

  Future<List<ChildUsageStats>> getUsageStats();

  /// Lịch sử của một trẻ, mới nhất trước, có phân trang.
  Future<List<UsageLog>> getLogsForChild(
    String childId, {
    required int limit,
    int offset = 0,
  });
  Future<List<WeakTopic>> getWeakTopics(String childId, {required int limit});

  /// Xoá các phiên đã kết thúc trước [cutoff]. Trả về số phiên đã xoá.
  Future<int> deleteEndedBefore(DateTime cutoff);
}

/// Nền tảng đang chạy — mỗi nền tảng có cách khoá máy khác nhau.
enum DevicePlatform {
  /// Foreground service + đưa app lên trên + (tuỳ chọn) Device Owner.
  android,

  /// Screen Time API: chặn các ứng dụng đã chọn khi hết giờ.
  ios,

  /// Chế độ kiosk toàn màn hình.
  macos,

  /// Cửa sổ toàn màn hình luôn trên cùng + chặn phím hệ thống.
  windows,
  other;

  bool get isDesktop => this == macos || this == windows;
}

class DevicePermissions {
  const DevicePermissions({
    this.platform = DevicePlatform.other,
    this.screenTimeAuthorized = false,
    this.limitedAppsSelected = false,
    required this.overlay,
    required this.notifications,
    required this.deviceOwner,
    this.accessibility = false,
    this.androidSdk = 0,
    required this.supported,
    this.batteryUnrestricted = false,
    this.manufacturer = '',
  });

  /// App được miễn tối ưu pin (hệ thống không tự tắt dịch vụ đếm giờ).
  final bool batteryUnrestricted;

  /// Hãng sản xuất, viết thường (vd. "oppo", "realme", "xiaomi").
  final String manufacturer;

  OemFamily get oem => OemFamily.fromManufacturer(manufacturer);

  final DevicePlatform platform;

  /// iOS: người lớn đã cấp quyền Screen Time (Family Controls) cho KidGuard.
  final bool screenTimeAuthorized;

  /// iOS: đã chọn các ứng dụng sẽ bị chặn khi hết giờ.
  final bool limitedAppsSelected;

  /// "Hiển thị trên ứng dụng khác" — để đưa màn câu hỏi lên khi hết giờ.
  final bool overlay;
  final bool notifications;

  /// Cũ: app là Device Owner (khoá cứng bật qua adb). Chỉ còn dùng để tắt.
  final bool deviceOwner;

  /// Android: "Khoá nâng cao" — Trợ năng của KidGuard đang bật.
  final bool accessibility;

  /// Android: API level của máy (0 nếu không phải Android).
  final int androidSdk;

  /// Nền tảng có hỗ trợ kiểm soát ngoài app hay không (Android: có, iOS: không).
  final bool supported;
}

/// Nhóm hãng điện thoại có cách quản lý chạy nền giống nhau.
enum OemFamily {
  xiaomi('Xiaomi / Redmi / POCO', 'MIUI / HyperOS'),
  oppo('Oppo / Realme / OnePlus', 'ColorOS'),
  vivo('Vivo / iQOO', 'Funtouch OS / OriginOS'),
  samsung('Samsung', 'One UI'),
  huawei('Huawei / Honor', 'EMUI / MagicOS'),
  other('Android', 'Android');

  const OemFamily(this.brandName, this.osName);
  final String brandName;
  final String osName;

  /// Hãng có quyền riêng "Hiển thị cửa sổ bật lên khi chạy trong nền".
  bool get hasBackgroundPopupPermission =>
      this == OemFamily.xiaomi || this == OemFamily.vivo;

  /// Hãng có màn "Tự khởi động" riêng.
  bool get hasAutoStart => this != OemFamily.samsung && this != OemFamily.other;

  static OemFamily fromManufacturer(String m) => switch (m.toLowerCase()) {
    'xiaomi' || 'redmi' || 'poco' => OemFamily.xiaomi,
    'oppo' || 'realme' || 'oneplus' => OemFamily.oppo,
    'vivo' || 'iqoo' => OemFamily.vivo,
    'samsung' => OemFamily.samsung,
    'huawei' || 'honor' => OemFamily.huawei,
    _ => OemFamily.other,
  };
}

/// Kiểu cấp quyền Family Controls trên iOS.
enum ScreenTimeAuthMode {
  /// Máy đăng nhập Apple ID trẻ em trong Family Sharing — bé khó vượt.
  child,

  /// Máy của phụ huynh cho bé mượn — bé có thể xoá app / tắt quyền.
  individual,
}

/// Kết quả xin quyền Screen Time (iOS).
class ScreenTimeAuthResult {
  const ScreenTimeAuthResult({
    required this.approved,
    required this.mode,
    this.errorCode,
  });

  final bool approved;
  final ScreenTimeAuthMode mode;

  /// cancelled | unavailable | restricted | invalidAccount | denied | failed
  final String? errorCode;
}

/// Điều khiển cấp thiết bị: đồng hồ chạy nền, giữ app luôn ở trên khi khoá.
abstract interface class DeviceControlRepository {
  Future<void> startTimer(DateTime endsAt);
  Future<void> setGuard(bool enabled);

  /// Tạm dừng việc "kéo app lên lại" trong lúc hiện hộp thoại xác thực của hệ thống.
  Future<void> suspendGuard(bool suspended);
  Future<void> stop();
  Future<void> moveToBackground();
  Future<DevicePermissions> getPermissions();
  Future<void> requestOverlayPermission();
  Future<void> requestNotificationPermission();
  /// Mở trang cài đặt tối ưu pin của hệ thống (không cần quyền đặc biệt).
  Future<void> openBatteryOptimizationSettings();

  /// Mở màn "Tự khởi động" của hãng. Trả về false nếu chỉ mở được trang thông tin app.
  Future<bool> openAutoStartSettings();

  /// Mở trang quyền "bật lên khi chạy nền" (Xiaomi/Vivo). False nếu chỉ mở được trang thông tin app.
  Future<bool> openBackgroundPopupSettings();
  Future<void> openAppSettings();

  /// Android: mở trang Trợ năng của KidGuard (hoặc danh sách Trợ năng).
  Future<void> openAccessibilitySettings();

  /// Tắt khoá cứng cũ (Device Owner). Trả về true nếu đã gỡ thành công.
  Future<bool> clearDeviceOwner();

  /// iOS: xin quyền Screen Time (`.child` hoặc `.individual`).
  Future<ScreenTimeAuthResult> requestScreenTimeAuthorization({
    ScreenTimeAuthMode mode = ScreenTimeAuthMode.child,
  });

  /// iOS: mở bảng chọn ứng dụng của Apple để chọn các app bị chặn khi hết giờ.
  Future<bool> chooseLimitedApps();
}

/// Ghi nhớ các bước thiết lập mà hệ thống không cho app tự kiểm tra
/// (vd. "Tự khởi động" trên Oppo/Xiaomi) — do người lớn tự xác nhận đã bật.
abstract interface class SetupChecklistRepository {
  Future<Set<String>> getConfirmed();
  Future<void> setConfirmed(String key, bool confirmed);
}

/// Ghi nhớ Khoá nâng cao (Trợ năng Android) đã từng bật trên máy này.
abstract interface class AdvancedLockMemoryRepository {
  Future<bool> wasSeenOn();
  Future<void> setSeenOn(bool seenOn);
}

/// Đồng ý của phụ huynh lần đầu mở app (trước khi lưu hồ sơ trẻ).
abstract interface class ParentConsentRepository {
  Future<bool> hasAccepted();
  Future<void> accept();
}

enum ParentAuthResult { success, failed, notAvailable }

/// Xác thực người lớn bằng mật khẩu / khoá màn hình của máy.
abstract interface class ParentAuthRepository {
  Future<bool> isAvailable();
  Future<ParentAuthResult> authenticate(String reason);
}
