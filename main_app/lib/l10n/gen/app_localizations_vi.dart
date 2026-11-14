// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'KidGuard';

  @override
  String durationSeconds(int count) {
    return '$count giây';
  }

  @override
  String durationMinutes(int count) {
    return '$count phút';
  }

  @override
  String durationHours(int count) {
    return '$count giờ';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours giờ $minutes phút';
  }

  @override
  String get questionTypeAcademic => 'Môn học';

  @override
  String get questionTypeOpen => 'Câu hỏi mở';

  @override
  String get questionTypeSocial => 'Kiến thức xã hội';

  @override
  String get validationNameRequired => 'Con hãy nhập đầy đủ họ tên nhé.';

  @override
  String get validationDobRequired => 'Con hãy chọn ngày sinh nhé.';

  @override
  String get validationDobInvalid => 'Ngày sinh không hợp lệ.';

  @override
  String get validationGradeRequired => 'Hãy chọn lớp hoặc bậc đang học.';

  @override
  String get authFailed => 'Mật khẩu không đúng hoặc đã huỷ xác thực.';

  @override
  String get authNotAvailable =>
      'Máy chưa cài mật khẩu màn hình khoá. Hãy vào Cài đặt để cài mã PIN/mật khẩu.';

  @override
  String get authReasonRevoke =>
      'Nhập mật khẩu máy để thu hồi điện thoại và tắt chế độ trẻ em';

  @override
  String get authReasonParentArea =>
      'Nhập mật khẩu máy để vào khu vực phụ huynh';

  @override
  String get authReasonDisableHardLock => 'Nhập mật khẩu máy để tắt khoá cứng';

  @override
  String get setupBack => 'Bấm nút Quay lại (◁) để trở về KidGuard.';

  @override
  String get setupOverlayTitle => 'Hiển thị trên ứng dụng khác';

  @override
  String get setupOverlayStepOpenPage =>
      'Máy mở trang \"Hiển thị trên các ứng dụng khác\" của KidGuard.';

  @override
  String get setupOverlayStepOpenList =>
      'Máy mở DANH SÁCH các ứng dụng. Kéo xuống (hoặc dùng ô tìm kiếm 🔍) tìm KidGuard và chạm vào.';

  @override
  String get setupOverlayStepToggle =>
      'Bật công tắc \"Cho phép hiển thị trên ứng dụng khác\".';

  @override
  String get setupOverlayNote =>
      'Chỉ bật cho KidGuard, các ứng dụng khác để nguyên.';

  @override
  String get setupAutoStartOppoTitle =>
      'Tự khởi động (Oppo / Realme / OnePlus)';

  @override
  String get setupAutoStartOppoStep1 =>
      'Máy mở trang \"Thông tin ứng dụng\" của KidGuard.';

  @override
  String get setupAutoStartOppoStep2 =>
      'Kéo xuống, chạm vào \"Mức sử dụng pin\" (hoặc \"Sử dụng pin\").';

  @override
  String get setupAutoStartOppoStep3 =>
      'Bật TẤT CẢ công tắc trong trang này, gồm: \"Cho phép hoạt động trong nền\", \"Cho phép tự khởi động\" (hoặc \"Tự động khởi chạy\"), \"Cho phép khởi chạy bởi ứng dụng khác\" nếu có.';

  @override
  String get setupAutoStartOppoStep4 =>
      'Nếu có mục \"Tối ưu hoá mức sử dụng pin\" thì chọn \"Không tối ưu hoá\" / \"Cho phép\".';

  @override
  String get setupAutoStartOppoNote =>
      'Máy đời cũ (ColorOS 11 trở về trước): vào Trình quản lý điện thoại › Quản lý quyền riêng tư › Quản lý khởi động › bật KidGuard.';

  @override
  String get setupAutoStartXiaomiTitle =>
      'Tự khởi động (Xiaomi / Redmi / POCO)';

  @override
  String get setupAutoStartXiaomiStep1 => 'Máy mở danh sách \"Tự khởi động\".';

  @override
  String get setupFindAndToggle => 'Tìm KidGuard và bật công tắc bên cạnh.';

  @override
  String get setupAutoStartXiaomiNote =>
      'Nếu máy mở trang Thông tin ứng dụng: bật \"Tự khởi động\", rồi vào \"Tiết kiệm pin\" › chọn \"Không hạn chế\".';

  @override
  String get setupAutoStartVivoTitle => 'Tự khởi động (Vivo / iQOO)';

  @override
  String get setupAutoStartVivoStep1 =>
      'Máy mở danh sách \"Tự khởi động\" / \"Quản lý khởi động nền\".';

  @override
  String get setupAutoStartVivoNote =>
      'Nếu máy mở trang Thông tin ứng dụng: vào \"Quyền\" › \"Tự khởi động\" và bật.';

  @override
  String get setupAutoStartHuaweiTitle => 'Khởi chạy ứng dụng (Huawei / Honor)';

  @override
  String get setupAutoStartHuaweiStep1 =>
      'Máy mở danh sách \"Khởi chạy ứng dụng\".';

  @override
  String get setupAutoStartHuaweiStep2 =>
      'Tìm KidGuard và TẮT công tắc \"Quản lý tự động\".';

  @override
  String get setupAutoStartHuaweiStep3 =>
      'Hộp thoại hiện ra: bật cả 3 mục \"Tự khởi chạy\", \"Khởi chạy phụ\", \"Chạy trong nền\" › OK.';

  @override
  String get setupAutoStartTitle => 'Tự khởi động';

  @override
  String get setupAutoStartStep1 =>
      'Máy mở trang Thông tin ứng dụng của KidGuard.';

  @override
  String get setupAutoStartStep2 => 'Vào \"Pin\" › chọn \"Không hạn chế\".';

  @override
  String get setupPopupXiaomiTitle => 'Bật lên khi chạy nền (Xiaomi)';

  @override
  String get setupPopupXiaomiStep1 =>
      'Máy mở trang \"Quyền khác\" của KidGuard.';

  @override
  String get setupPopupXiaomiStep2 =>
      'Chạm \"Hiển thị cửa sổ bật lên khi chạy trong nền\" › chọn \"Luôn cho phép\".';

  @override
  String get setupPopupXiaomiStep3 =>
      'Chạm \"Hiển thị cửa sổ bật lên\" › chọn \"Luôn cho phép\".';

  @override
  String get setupPopupXiaomiNote =>
      'Nếu máy mở trang Thông tin ứng dụng: vào \"Quyền ứng dụng\" › \"Quyền khác\".';

  @override
  String get setupPopupVivoTitle => 'Bật lên khi chạy nền (Vivo)';

  @override
  String get setupPopupVivoStep1 => 'Máy mở trang quyền của KidGuard.';

  @override
  String get setupPopupVivoStep2 =>
      'Bật \"Hiển thị cửa sổ bật lên khi chạy trong nền\" (có máy ghi là \"Khởi động ứng dụng từ nền\").';

  @override
  String get setupPopupVivoNote =>
      'Nếu máy mở trang Thông tin ứng dụng: vào \"Quyền\" › \"Quyền khác\".';

  @override
  String get setupRecentsTitle => 'Khoá KidGuard trong đa nhiệm';

  @override
  String get setupRecentsStepOpen =>
      'Mở màn đa nhiệm: vuốt từ cạnh dưới lên và giữ (hoặc bấm nút ▢).';

  @override
  String get setupRecentsStepOppo =>
      'Trên thẻ KidGuard, bấm nút ⋮ ở góc trên (hoặc vuốt thẻ xuống) › chọn \"Khoá\".';

  @override
  String get setupRecentsStepXiaomi =>
      'Nhấn giữ thẻ KidGuard › chạm biểu tượng ổ khoá 🔒.';

  @override
  String get setupRecentsStepVivo =>
      'Vuốt thẻ KidGuard xuống (hoặc nhấn giữ) › chọn \"Khoá\" 🔒.';

  @override
  String get setupRecentsStepHuawei =>
      'Vuốt thẻ KidGuard xuống › chạm biểu tượng ổ khoá 🔒.';

  @override
  String get setupRecentsStepSamsung =>
      'Chạm biểu tượng KidGuard phía trên thẻ › chọn \"Giữ mở\" (Keep open).';

  @override
  String get setupRecentsStepOther =>
      'Nhấn giữ thẻ KidGuard, nếu có tuỳ chọn \"Khoá\" / \"Ghim\" thì chọn.';

  @override
  String get setupRecentsStepDone =>
      'Thẻ KidGuard có biểu tượng ổ khoá là xong. Quay lại KidGuard.';

  @override
  String get setupRecentsNote =>
      'Khi đã khoá, bé bấm \"Dọn dẹp tất cả\" cũng không tắt được KidGuard.';

  @override
  String get setupConfirmQuestion =>
      'Bạn đã làm xong bước này cho KidGuard chưa?';

  @override
  String get setupConfirmAgain => 'Chưa, làm lại';

  @override
  String get setupConfirmDone => 'Đã xong';

  @override
  String get setupReadStepsFirst =>
      'Đọc trước các bước, sau đó bấm \"Mở cài đặt\":';

  @override
  String get setupFollowSteps => 'Làm theo các bước sau:';

  @override
  String get setupOpenSettings => 'Mở cài đặt';

  @override
  String get setupGotIt => 'Đã hiểu';

  @override
  String get homeParentArea => 'Khu vực phụ huynh';

  @override
  String get homeParentAreaSubtitle =>
      'Xem thời gian dùng máy, câu đúng/sai của từng bé';

  @override
  String get homeSetupHeader => 'Thiết lập trên máy này';

  @override
  String get homeScreenLockTitle => 'Mật khẩu màn hình khoá';

  @override
  String get homeScreenLockSubtitle =>
      'Bắt buộc — dùng để người lớn thu hồi máy và mở khoá.';

  @override
  String get homeOverlaySubtitle =>
      'Để màn câu hỏi tự hiện lên khi hết giờ, kể cả khi bé đang ở app khác.';

  @override
  String get homePopupTitle => 'Hiển thị cửa sổ bật lên khi chạy nền';

  @override
  String get homeConfirmedOn => 'Bạn đã xác nhận bật.';

  @override
  String homePopupSubtitle(String brand) {
    return 'Quyền riêng của $brand. Thiếu quyền này, hết giờ màn câu hỏi sẽ không tự hiện lên.';
  }

  @override
  String get homeReview => 'Xem lại';

  @override
  String get homeGuide => 'Hướng dẫn';

  @override
  String get homeNotificationsTitle => 'Thông báo';

  @override
  String get homeNotificationsSubtitle =>
      'Hiện đồng hồ đếm ngược trên thanh thông báo.';

  @override
  String get homeBatteryTitle => 'Không giới hạn pin';

  @override
  String get homeBatterySubtitle =>
      'Để hệ thống không tự tắt bộ đếm giờ khi bé dùng app khác.';

  @override
  String get homeAutoStartSubtitle =>
      'Để chế độ khoá vẫn hoạt động khi bé dọn đa nhiệm hoặc khởi động lại máy.';

  @override
  String get homeConfirmedLocked => 'Bạn đã xác nhận khoá.';

  @override
  String get homeRecentsSubtitle =>
      'Để nút \"Dọn dẹp tất cả\" không tắt được KidGuard.';

  @override
  String get homeHardLockTitle => 'Khoá cứng — tuỳ chọn, khuyên dùng';

  @override
  String get homeHardLockOn =>
      'Đang bật: bé không thể thoát màn khoá bằng bất kỳ cách nào.';

  @override
  String get homeHardLockOff =>
      'Chặn hoàn toàn nút Home, Đa nhiệm, thanh thông báo khi khoá máy. Cần máy tính, làm 1 lần.';

  @override
  String get homeManage => 'Quản lý';

  @override
  String get homeIosNotice =>
      'Hết giờ, Screen Time sẽ chặn các ứng dụng đã chọn. Bé mở KidGuard để trả lời câu hỏi. Muốn khoá chặt hơn, bật thêm Truy cập được hướng dẫn (Cài đặt › Trợ năng › Truy cập được hướng dẫn).';

  @override
  String get homeHeroTitle => '🧒  Cho bé mượn máy';

  @override
  String get homeHeroBody =>
      'Bé được dùng 15 phút. Hết giờ, bé trả lời 1 câu hỏi theo lớp đang học: đúng được thêm 5 phút, sai thì máy khoá cho tới khi bố mẹ mở.';

  @override
  String get homeStartKidMode => 'Bắt đầu chế độ trẻ em';

  @override
  String get homeGrant => 'Cấp quyền';

  @override
  String get hardLockTitle => 'Khoá cứng';

  @override
  String get hardLockDisableTitle => 'Tắt khoá cứng?';

  @override
  String get hardLockDisableBody =>
      'KidGuard vẫn hoạt động bình thường nhưng khi khoá máy, bé có thể vuốt thanh điều hướng (chỉ bị kéo lại sau ~1 giây). Cần tắt khoá cứng trước khi gỡ cài đặt KidGuard.';

  @override
  String get hardLockCancel => 'Huỷ';

  @override
  String get hardLockTurnOff => 'Tắt';

  @override
  String get hardLockDisabledOk =>
      'Đã tắt khoá cứng. Giờ có thể gỡ KidGuard như ứng dụng bình thường.';

  @override
  String get hardLockDisableFailed => 'Không tắt được khoá cứng.';

  @override
  String get hardLockDisableButton => 'Tắt khoá cứng (cần mật khẩu máy)';

  @override
  String get hardLockIntro =>
      'Chỉ cần làm 1 lần, mất khoảng 10 phút, cần 1 máy tính và cáp USB.';

  @override
  String get hardLockStep1Title => 'Bật Tuỳ chọn nhà phát triển';

  @override
  String hardLockStep1UsbDebugging(String location) {
    return 'Vào $location › bật \"Gỡ lỗi USB\".';
  }

  @override
  String get hardLockStep2Title => 'Tạm xoá tài khoản & người dùng phụ';

  @override
  String get hardLockStep2Accounts =>
      'Android chỉ cho bật khoá cứng khi máy KHÔNG có tài khoản nào. Vào Cài đặt › Người dùng & tài khoản (hoặc \"Tài khoản\") và xoá hết: Google, tài khoản hãng (HeyTap/Oppo, Mi, Samsung…), cả tài khoản của app như Zalo, Telegram, WhatsApp nếu có trong danh sách.';

  @override
  String get hardLockStep2NoDataLoss =>
      'Dữ liệu không bị mất. Làm xong bước 4 là đăng nhập lại được ngay.';

  @override
  String get hardLockStep3Title => 'Chuẩn bị máy tính';

  @override
  String get hardLockStep3Mac =>
      'macOS: mở Terminal và chạy lệnh dưới (cần Homebrew):';

  @override
  String get hardLockStep3Windows =>
      'Windows: tải \"SDK Platform-Tools for Windows\" tại developer.android.com/tools/releases/platform-tools, giải nén, mở thư mục platform-tools, gõ \"cmd\" vào thanh địa chỉ rồi Enter để mở cửa sổ lệnh.';

  @override
  String get hardLockStep3Plug =>
      'Cắm cáp USB. Trên điện thoại hiện \"Cho phép gỡ lỗi USB?\" › tick \"Luôn cho phép\" › Cho phép. Nếu được hỏi chế độ USB, chọn \"Truyền tệp\".';

  @override
  String get hardLockStep3Check =>
      'Kiểm tra kết nối — phải thấy 1 dòng kết thúc bằng \"device\":';

  @override
  String get hardLockStep4Title => 'Bật khoá cứng';

  @override
  String get hardLockStep4Run => 'Chạy lệnh:';

  @override
  String get hardLockStep4Success =>
      'Thành công khi thấy \"Success: Device owner set to package com.pham.kidguard\". Quay lại app, trạng thái ở trên sẽ chuyển xanh.';

  @override
  String get hardLockStep4After =>
      'Giờ có thể đăng nhập lại các tài khoản, tắt \"Gỡ lỗi USB\" và rút cáp.';

  @override
  String get hardLockTroubleTitle => 'Gặp lỗi?';

  @override
  String get hardLockErrAccountsFix =>
      'Còn tài khoản trên máy. Làm lại bước 2, kiểm tra kỹ cả tài khoản của các app.';

  @override
  String get hardLockErrSecurityFix =>
      'Máy chặn lệnh qua USB. Kiểm tra lại \"Gỡ lỗi USB\" trong Tuỳ chọn nhà phát triển.';

  @override
  String get hardLockErrUnknownAdminFix =>
      'KidGuard chưa được cài trên máy, hoặc gõ sai lệnh — hãy dùng nút sao chép.';

  @override
  String get hardLockErrNoDevice =>
      'adb devices không thấy máy / \"unauthorized\"';

  @override
  String get hardLockErrNoDeviceFix =>
      'Rút cáp cắm lại, mở khoá màn hình điện thoại và bấm \"Cho phép\" ở hộp thoại gỡ lỗi USB. Thử cáp khác (một số cáp chỉ sạc được).';

  @override
  String get hardLockErrNoAdbFix =>
      'Chưa cài platform-tools (bước 3). Trên Windows phải mở cửa sổ lệnh ngay trong thư mục platform-tools.';

  @override
  String get hardLockStatusOn => 'Khoá cứng đang BẬT';

  @override
  String get hardLockStatusOff => 'Khoá cứng đang tắt';

  @override
  String get hardLockStatusOnBody =>
      'Khi khoá máy, bé không thể bấm Home, Đa nhiệm, kéo thanh thông báo hay buộc dừng app. Chỉ mật khẩu máy mới mở được.';

  @override
  String get hardLockStatusOffBody =>
      'Không bật khoá cứng thì KidGuard vẫn kéo màn khoá lên lại khi bé thoát ra, nhưng bé có thể thấy màn hình khác trong ~1 giây và có thể vào Cài đặt để buộc dừng app nếu đủ nhanh. Khoá cứng chặn hoàn toàn việc này.';

  @override
  String get hardLockCopy => 'Sao chép';

  @override
  String get hardLockCopied => 'Đã sao chép lệnh';

  @override
  String get hardLockDevOppoEnable =>
      'Cài đặt › Giới thiệu về thiết bị › Phiên bản › chạm liên tục 7 lần vào \"Số phiên bản\" và nhập mật khẩu máy.';

  @override
  String get hardLockDevLocationAdditional =>
      'Cài đặt › Cài đặt bổ sung › Tuỳ chọn nhà phát triển';

  @override
  String get hardLockDevOppoUsers =>
      'Xoá \"Không gian thứ hai\", \"Nhân bản ứng dụng\" và người dùng khách (Cài đặt › Ứng dụng › Nhân bản ứng dụng; Cài đặt › Người dùng & tài khoản).';

  @override
  String get hardLockDevOppoExtra =>
      'Riêng Oppo/Realme: trong Tuỳ chọn nhà phát triển, bật thêm \"Tắt giám sát quyền\" (Disable permission monitoring). Thiếu mục này lệnh ở bước 4 sẽ bị từ chối.';

  @override
  String get hardLockDevXiaomiEnable =>
      'Cài đặt › Giới thiệu điện thoại › chạm liên tục 7 lần vào \"Phiên bản HyperOS/MIUI\".';

  @override
  String get hardLockDevXiaomiUsers =>
      'Xoá \"Không gian thứ hai\" và \"Ứng dụng kép\" (Cài đặt › Ứng dụng › Ứng dụng kép).';

  @override
  String get hardLockDevXiaomiExtra =>
      'Riêng Xiaomi: bật thêm \"Gỡ lỗi USB (Cài đặt bảo mật)\" — mục này cần lắp SIM và đăng nhập Mi account; bật xong mới xoá tài khoản ở bước 2.';

  @override
  String get hardLockDevVivoEnable =>
      'Cài đặt › Hệ thống › Giới thiệu › Thông tin phần mềm › chạm liên tục 7 lần vào \"Phiên bản phần mềm\".';

  @override
  String get hardLockDevLocationSystem =>
      'Cài đặt › Hệ thống › Tuỳ chọn nhà phát triển';

  @override
  String get hardLockDevVivoUsers =>
      'Xoá \"Ứng dụng nhân bản\" và người dùng khách.';

  @override
  String get hardLockDevSamsungEnable =>
      'Cài đặt › Thông tin điện thoại › Thông tin phần mềm › chạm liên tục 7 lần vào \"Số hiệu bản tạo\".';

  @override
  String get hardLockDevSamsungLocation =>
      'Cài đặt › Tuỳ chọn nhà phát triển (cuối danh sách)';

  @override
  String get hardLockDevSamsungUsers =>
      'Xoá \"Thư mục bảo mật\" (Secure Folder) và \"Dual Messenger\" nếu có.';

  @override
  String get hardLockDevGenericEnable =>
      'Cài đặt › Giới thiệu điện thoại › chạm liên tục 7 lần vào \"Số bản dựng\".';

  @override
  String get hardLockDevHuaweiLocation =>
      'Cài đặt › Hệ thống & cập nhật › Tuỳ chọn nhà phát triển';

  @override
  String get hardLockDevHuaweiUsers =>
      'Xoá \"Không gian riêng tư\", \"Ứng dụng song song\" và người dùng khách.';

  @override
  String get hardLockDevOtherUsers =>
      'Xoá người dùng khách, hồ sơ công việc và ứng dụng nhân bản nếu có.';

  @override
  String get registerTitle => 'Thông tin của bé';

  @override
  String get registerGreeting => 'Chào con! 👋';

  @override
  String get registerIntro =>
      'Con điền đủ thông tin để được dùng máy 15 phút nhé.';

  @override
  String get registerNameLabel => 'Họ và tên';

  @override
  String get registerNameHint => 'Ví dụ: Nguyễn Minh An';

  @override
  String get registerDobLabel => 'Ngày sinh';

  @override
  String get registerDobPick => 'Chọn ngày sinh';

  @override
  String get registerGradeLabel => 'Bạn đang học lớp mấy / bậc nào?';

  @override
  String registerGradeChip(int grade) {
    return 'Lớp $grade';
  }

  @override
  String get registerLevelPrimary => 'Tiểu học';

  @override
  String get registerLevelLowerSecondary => 'THCS';

  @override
  String get registerLevelUpperSecondary => 'THPT';

  @override
  String get registerHigherEducation => 'Bậc cao hơn';

  @override
  String get gradeUniversity => 'Đại học';

  @override
  String get gradeUniversityHint => 'Cao đẳng, đại học';

  @override
  String get gradePostgraduate => 'Sau đại học';

  @override
  String get gradePostgraduateHint => 'Thạc sĩ, tiến sĩ';

  @override
  String get registerNeedsScreenLock =>
      'Máy chưa cài mật khẩu màn hình khoá. Bố mẹ cần cài mật khẩu trước để có thể thu hồi máy.';

  @override
  String registerErrorGeneric(String error) {
    return 'Có lỗi xảy ra: $error';
  }

  @override
  String get registerStart => 'Bắt đầu dùng máy';

  @override
  String runningGreeting(String name) {
    return 'Chào $name!';
  }

  @override
  String runningGrade(String grade) {
    return '$grade';
  }

  @override
  String get runningTimeLeft => 'Thời gian còn lại';

  @override
  String get runningRules =>
      'Hết giờ, con sẽ trả lời 1 câu hỏi.\nĐúng được thêm 5 phút, sai thì máy sẽ bị khoá.';

  @override
  String get runningUseOtherApps => 'Dùng ứng dụng khác';

  @override
  String get quizCorrect => '🎉 Chính xác! Con được dùng thêm 5 phút.';

  @override
  String get quizTimeUp => 'Hết giờ rồi!';

  @override
  String get quizInstruction => 'Trả lời đúng để được dùng thêm 5 phút nhé.';

  @override
  String get quizSubmit => 'Trả lời';

  @override
  String get reviewWrong => 'Chưa đúng rồi!';

  @override
  String get reviewYourChoice => 'Con chọn';

  @override
  String get reviewCorrectAnswer => 'Đáp án đúng';

  @override
  String get reviewSuggestionTitle => 'Gợi ý ôn tập';

  @override
  String get reviewLockNotice =>
      'Khi con bấm OK, máy sẽ bị khoá. Con hãy đưa máy cho bố mẹ nhé.';

  @override
  String get commonOk => 'OK';

  @override
  String get lockedTitle => 'Máy đã bị khoá';

  @override
  String lockedMessage(String name) {
    return '$name ơi, con hãy đưa máy cho bố mẹ nhé.\nNhớ ôn lại phần kiến thức vừa được gợi ý!';
  }

  @override
  String get lockedUnlockButton => 'Người lớn mở khoá & thu hồi máy';

  @override
  String get revokeButton => 'Người lớn thu hồi máy';

  @override
  String get dashboardTitle => 'Khu vực phụ huynh';

  @override
  String get dashboardEmpty => 'Chưa có bé nào dùng máy.';

  @override
  String get dashboardTotalTime => 'Tổng thời gian';

  @override
  String get dashboardCorrect => 'Đúng';

  @override
  String get dashboardWrong => 'Sai';

  @override
  String get dashboardChildren => 'Các bé';

  @override
  String dashboardChildInfo(String grade, int age) {
    return '$grade · $age tuổi';
  }

  @override
  String reportChildInfo(String grade, String dob) {
    return '$grade · Sinh ngày $dob';
  }

  @override
  String get reportTimeUsed => 'Đã dùng';

  @override
  String get reportCorrect => 'Đúng';

  @override
  String get reportWrong => 'Sai';

  @override
  String get reportWeakTopicsTitle => 'Kiến thức cần củng cố';

  @override
  String reportWrongTimes(int count) {
    return 'sai $count lần';
  }

  @override
  String reportHistoryTitle(int count) {
    return 'Lịch sử sử dụng ($count phiên)';
  }

  @override
  String get reportNoSessions => 'Chưa có phiên nào.';

  @override
  String get reportLoadMore => 'Tải thêm';

  @override
  String reportLogRetention(int days) {
    return 'Nhật ký được lưu tối đa $days ngày.';
  }

  @override
  String get reportStatusActive => 'Đang diễn ra';

  @override
  String get reportStatusLocked => 'Bị khoá do trả lời sai';

  @override
  String get reportStatusRevoked => 'Người lớn thu hồi';

  @override
  String reportSessionSummary(
    String duration,
    int count,
    int correct,
    int wrong,
  ) {
    return 'Dùng $duration · $count câu (✅ $correct  ❌ $wrong)';
  }

  @override
  String reportEndedAt(String time) {
    return 'Kết thúc: $time';
  }

  @override
  String get reportNoAttempts => 'Chưa trả lời câu hỏi nào.';

  @override
  String reportAttemptTitle(int number, String subject, String topic) {
    return 'Câu $number · $subject — $topic';
  }

  @override
  String reportChosenAnswer(String letter, String option) {
    return 'Bé chọn: $letter. $option';
  }

  @override
  String reportCorrectAnswer(String letter, String option) {
    return 'Đáp án đúng: $letter. $option';
  }

  @override
  String quizLoadError(String error) {
    return 'Không tải được câu hỏi: $error';
  }

  @override
  String get homeScreenTimeTitle => 'Quyền Screen Time';

  @override
  String get homeScreenTimeSubtitle =>
      'Cho phép KidGuard chặn các ứng dụng bạn chọn khi hết giờ. Xác nhận bằng Face ID hoặc mật khẩu máy.';

  @override
  String get homeLimitedAppsTitle => 'Ứng dụng bị chặn khi hết giờ';

  @override
  String get homeLimitedAppsSubtitle =>
      'Chọn ứng dụng hoặc nhóm ứng dụng (vd. Trò chơi, Mạng xã hội, Giải trí). Không chọn KidGuard.';

  @override
  String get homeLimitedAppsOn =>
      'Đã chọn. Có thể thay đổi danh sách bất cứ lúc nào.';

  @override
  String get homeLimitedAppsChoose => 'Chọn';

  @override
  String get homeLimitedAppsChange => 'Đổi';

  @override
  String get homeScreenTimeFirst => 'Hãy cấp quyền Screen Time trước.';

  @override
  String get homeDesktopTitle => 'Cách khoá trên máy tính này';

  @override
  String get homeMacNotice =>
      'Hết giờ, KidGuard hiện lên toàn màn hình ở chế độ kiosk: Dock, thanh menu, Cmd+Tab và Buộc thoát đều bị vô hiệu cho tới khi bé trả lời câu hỏi hoặc người lớn mở khoá bằng mật khẩu Mac / Touch ID. Trong phiên, KidGuard không thể bị tắt và tự mở lại sau khi đăng nhập.';

  @override
  String get homeWindowsNotice =>
      'Hết giờ, KidGuard phủ kín màn hình và luôn nằm trên cùng: phím Windows, Alt+Tab và Alt+F4 bị chặn cho tới khi bé trả lời câu hỏi hoặc người lớn mở khoá bằng Windows Hello (PIN, vân tay hoặc khuôn mặt). Trong phiên, KidGuard không thể bị đóng và tự mở lại sau khi đăng nhập. Windows không cho ứng dụng chặn Ctrl+Alt+Del.';

  @override
  String get homeWindowsHelloHint =>
      'Cần cài Windows Hello (Cài đặt › Tài khoản › Tuỳ chọn đăng nhập › Mã PIN).';

  @override
  String get runningIosHint =>
      'Vuốt lên (hoặc bấm nút Home) để dùng ứng dụng khác.';
}
