/// Quy tắc nghiệp vụ cố định của app.
class AppConstants {
  AppConstants._();

  /// Thời gian được dùng ngay khi bắt đầu phiên, nếu người lớn chưa đặt.
  static const Duration defaultInitialAllowance = Duration(minutes: 15);

  /// Người lớn đặt thời gian ban đầu tối thiểu bằng này (không giới hạn tối đa).
  static const Duration minInitialAllowance = Duration(minutes: 5);

  /// Thời gian thưởng cho mỗi câu trả lời đúng.
  static const Duration bonusPerCorrectAnswer = Duration(minutes: 5);

  /// Việc học: lựa chọn phần thưởng (phút) và thời gian việc hẹn giờ (phút).
  static const List<int> taskRewardChoices = [5, 10, 15, 20, 30, 45, 60];
  static const List<int> taskDurationChoices = [5, 10, 15, 20, 30, 45, 60];
  static const Duration defaultTaskReward = Duration(minutes: 15);
  static const Duration defaultTaskDuration = Duration(minutes: 20);
  static const int maxTaskTitleLength = 80;

  /// Lớp 1..12 là phổ thông; 13 = Đại học, 14 = Sau đại học.
  static const int minGrade = 1;
  static const int maxSchoolGrade = 12;
  static const int universityGrade = 13;
  static const int postgraduateGrade = 14;
  static const int maxGrade = postgraduateGrade;

  /// Không lặp lại các câu đã hỏi gần đây của cùng một trẻ.
  static const int recentQuestionWindow = 40;

  /// Tự động xoá nhật ký cũ hơn khoảng này để dữ liệu không phình mãi.
  static const Duration logRetention = Duration(days: 180);

  /// Chính sách quyền riêng tư công khai (dùng cho store listing + in-app).
  static const String privacyPolicyUrl =
      'https://github.com/duc1205/kid_guard/blob/main/PRIVACY.md';

  /// Nguồn câu hỏi mặc định: repo GitHub công khai chỉ chứa câu hỏi
  /// (manifest.json + grade_N.json, cùng định dạng assets/questions/).
  static const String defaultQuestionSourceUrl =
      'https://raw.githubusercontent.com/duc1205/kid_guard_question/main/manifest.json';

  /// Tự kiểm tra bản câu hỏi mới khi mở app / quay lại app, tối đa 1 lần mỗi
  /// khoảng này (chỉ tải manifest ~2 KB; file câu hỏi chỉ tải khi đổi).
  static const Duration questionSyncInterval = Duration(minutes: 15);

  /// Giới hạn kích thước mỗi file tải về để tránh nguồn lạ làm đầy bộ nhớ.
  static const int maxQuestionFileBytes = 2 * 1024 * 1024;

  /// Số phiên tải mỗi lần trong màn lịch sử của phụ huynh.
  static const int historyPageSize = 20;
}
