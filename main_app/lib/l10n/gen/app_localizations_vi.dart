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
  String get homeManage => 'Quản lý';

  @override
  String get homeIosNotice =>
      'Hết giờ, Screen Time sẽ chặn các ứng dụng đã chọn. Bé mở KidGuard để trả lời câu hỏi. Muốn khoá chặt hơn, bật thêm Truy cập được hướng dẫn (Cài đặt › Trợ năng › Truy cập được hướng dẫn).';

  @override
  String get homeHeroTitle => '🧒  Cho bé mượn máy';

  @override
  String homeHeroBody(String duration) {
    return 'Bé được dùng $duration. Hết giờ, bé trả lời 1 câu hỏi theo lớp đang học: đúng được thêm 5 phút, sai thì máy khoá cho tới khi bố mẹ mở.';
  }

  @override
  String get homeStartKidMode => 'Bắt đầu chế độ trẻ em';

  @override
  String get homeGrant => 'Cấp quyền';

  @override
  String get hardLockDisableTitle => 'Tắt khoá cứng?';

  @override
  String get hardLockDisableBody =>
      'KidGuard vẫn hoạt động bình thường (dùng Khoá nâng cao nếu đã bật). Bắt buộc tắt mục này trước khi gỡ KidGuard.';

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
  String get registerTitle => 'Thông tin của bé';

  @override
  String get registerGreeting => 'Chào con! 👋';

  @override
  String registerIntro(String duration) {
    return 'Con điền đủ thông tin để được dùng máy $duration nhé.';
  }

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

  @override
  String get commonCancel => 'Huỷ';

  @override
  String get dashboardQuestionSource => 'Nguồn câu hỏi';

  @override
  String get qsTitle => 'Nguồn câu hỏi';

  @override
  String get qsSource => 'Nguồn';

  @override
  String get qsDefaultSource => 'Mặc định (KidGuard)';

  @override
  String get qsCustomSource => 'Tuỳ chỉnh';

  @override
  String get qsVersion => 'Phiên bản bộ câu hỏi';

  @override
  String get qsDownloaded => 'Lớp dùng câu hỏi tải về';

  @override
  String get qsBundledOnly => 'Đang dùng bộ câu hỏi có sẵn trong app';

  @override
  String get qsLastSync => 'Kiểm tra lần cuối';

  @override
  String get qsNever => 'Chưa';

  @override
  String get qsSyncNow => 'Cập nhật ngay';

  @override
  String get qsChangeSource => 'Đổi nguồn câu hỏi';

  @override
  String get qsChangeTitle => 'Địa chỉ manifest.json';

  @override
  String get qsUseDefault => 'Dùng nguồn mặc định';

  @override
  String get qsSave => 'Lưu và tải';

  @override
  String get qsHelp =>
      'Câu hỏi được tải qua internet rồi lưu trên máy để dùng cả khi mất mạng. Mỗi file đều được kiểm tra định dạng và mã kiểm tra; nếu có lỗi, app giữ nguyên bộ câu hỏi đang có. Nguồn tuỳ chỉnh (ví dụ của nhà trường) cần một file manifest.json và các file grade_N.json cùng định dạng: lớp 1–12, 13 = Đại học, 14 = Sau đại học.';

  @override
  String qsResultUpdated(int version) {
    return 'Đã cập nhật bộ câu hỏi lên phiên bản $version.';
  }

  @override
  String get qsResultUpToDate => 'Bộ câu hỏi đã là bản mới nhất.';

  @override
  String get qsErrorNetwork =>
      'Không tải được câu hỏi (kiểm tra mạng hoặc địa chỉ). App tiếp tục dùng bộ câu hỏi đang có trên máy.';

  @override
  String get qsErrorManifest =>
      'manifest.json không đúng định dạng. App tiếp tục dùng bộ câu hỏi đang có trên máy.';

  @override
  String get qsErrorQuestions =>
      'Có file câu hỏi sai định dạng. App tiếp tục dùng bộ câu hỏi đang có trên máy.';

  @override
  String get qsErrorChecksum =>
      'File câu hỏi không khớp mã kiểm tra trong manifest. App tiếp tục dùng bộ câu hỏi đang có trên máy.';

  @override
  String get qsInvalidUrl => 'Địa chỉ không hợp lệ.';

  @override
  String get qsInsecureUrl => 'Chỉ chấp nhận địa chỉ bắt đầu bằng https://';

  @override
  String get registerPickTitle => 'Ai đang dùng máy nhỉ?';

  @override
  String registerPickIntro(String duration) {
    return 'Con chạm vào tên mình để được dùng máy $duration nhé.';
  }

  @override
  String get registerAddNew => 'Con chưa có tên trong danh sách';

  @override
  String get registerBackToList => 'Chọn tên đã lưu';

  @override
  String get registerSavedHint =>
      'Thông tin chưa đúng hoặc đã lên lớp? Nhờ bố mẹ sửa trong khu vực phụ huynh nhé.';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsInitialAllowance => 'Thời gian dùng ban đầu';

  @override
  String settingsInitialAllowanceDefault(String duration) {
    return '$duration (mặc định)';
  }

  @override
  String get settingsInitialAllowanceHint =>
      'Mỗi lần bắt đầu, bé được dùng máy bấy nhiêu thời gian trước câu hỏi đầu tiên. Áp dụng từ phiên tiếp theo.';

  @override
  String get settingsMinutesLabel => 'Số phút';

  @override
  String settingsMinutesMin(int min) {
    return 'Tối thiểu $min phút.';
  }

  @override
  String get settingsMinutesInvalid => 'Nhập số phút (số nguyên).';

  @override
  String settingsResetDefault(String duration) {
    return 'Dùng mặc định ($duration)';
  }

  @override
  String get settingsSave => 'Lưu';

  @override
  String get settingsCancel => 'Huỷ';

  @override
  String get childEditTooltip => 'Sửa thông tin';

  @override
  String get childEditTitle => 'Sửa thông tin của bé';

  @override
  String get childEditGradeLabel => 'Lớp / bậc học';

  @override
  String get childEditNote =>
      'Nhớ cập nhật lớp mỗi đầu năm học để câu hỏi đúng trình độ. Lịch sử cũ vẫn được giữ.';

  @override
  String childEditSaved(String name) {
    return 'Đã lưu thông tin của $name.';
  }

  @override
  String get homeAdvancedLockTitle => 'Khoá nâng cao (Trợ năng) — khuyên dùng';

  @override
  String get homeAdvancedLockOn =>
      'Đang bật: khi hết giờ, bé không kéo được thanh thông báo, không mở được đa nhiệm hay ứng dụng khác.';

  @override
  String get homeAdvancedLockOff =>
      'Bật trong Cài đặt › Trợ năng ngay trên máy, không cần máy tính. Chặn thanh thông báo, đa nhiệm và việc tắt KidGuard.';

  @override
  String get advancedLockTitle => 'Khoá nâng cao';

  @override
  String get advancedLockStatusOn => 'Khoá nâng cao đang BẬT';

  @override
  String get advancedLockStatusOff => 'Khoá nâng cao đang tắt';

  @override
  String get advancedLockStatusOnBody =>
      'Khi hết giờ hoặc máy bị khoá, KidGuard giữ màn câu hỏi trên màn hình và bé không thể tắt KidGuard trong phiên.';

  @override
  String get advancedLockStatusOffBody =>
      'KidGuard vẫn che màn hình khi hết giờ, nhưng bé vẫn kéo được thanh thông báo và có thể vào Cài đặt tắt KidGuard trong lúc được dùng máy.';

  @override
  String get advancedLockWhatTitle => 'Khoá nâng cao làm gì?';

  @override
  String get advancedLockWhat1 =>
      'Khi hết giờ hoặc máy bị khoá: đóng ngay thanh thông báo, chặn màn đa nhiệm, màn hình chính và chia đôi màn hình, đưa màn câu hỏi lên lại tức thì.';

  @override
  String get advancedLockWhat2 =>
      'Suốt phiên của bé: chặn mở trang cài đặt, buộc dừng và gỡ cài đặt KidGuard, kể cả việc tắt Trợ năng của KidGuard.';

  @override
  String get advancedLockWhat3 => 'Cuộc gọi đến và gọi khẩn cấp vẫn dùng được.';

  @override
  String get advancedLockPrivacy =>
      'KidGuard chỉ dùng Trợ năng để biết ứng dụng nào đang ở trên cùng; không đọc, không lưu, không gửi nội dung màn hình.';

  @override
  String get advancedLockStepsTitle => 'Cách bật (khoảng 1 phút)';

  @override
  String get advancedLockStepRestricted =>
      'Android 13 trở lên, nếu KidGuard không cài từ CH Play: mở Thông tin ứng dụng KidGuard › bấm ⋮ ở góc trên bên phải › \"Cho phép cài đặt hạn chế\" › nhập mật khẩu máy. Không thấy mục này thì bỏ qua bước này.';

  @override
  String get advancedLockOpenAppInfo => 'Mở Thông tin ứng dụng';

  @override
  String get advancedLockStepEnable =>
      'Bấm nút bên dưới › chọn KidGuard (thường nằm trong \"Ứng dụng đã tải xuống\" hoặc \"Ứng dụng đã cài đặt\") › bật › Cho phép.';

  @override
  String get advancedLockOpenSettings => 'Mở cài đặt Trợ năng';

  @override
  String get advancedLockStepBack =>
      'Quay lại KidGuard: trạng thái ở trên chuyển sang \"đang BẬT\".';

  @override
  String get advancedLockOffNote =>
      'Muốn tắt: thu hồi máy (kết thúc phiên của bé) trước, rồi vào Cài đặt › Trợ năng › KidGuard › tắt.';

  @override
  String get legacyHardLockTitle => 'Khoá cứng cũ (Device Owner) đang bật';

  @override
  String get legacyHardLockBody =>
      'Máy này đã bật khoá cứng bằng máy tính ở phiên bản trước. Cần tắt mục này trước khi gỡ KidGuard.';
}
