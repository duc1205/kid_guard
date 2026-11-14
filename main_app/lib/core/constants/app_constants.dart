/// Quy tắc nghiệp vụ cố định của app.
class AppConstants {
  AppConstants._();

  /// Thời gian được dùng ngay sau khi trẻ đăng ký thông tin.
  static const Duration initialAllowance = Duration(minutes: 15);

  /// Thời gian thưởng cho mỗi câu trả lời đúng.
  static const Duration bonusPerCorrectAnswer = Duration(minutes: 5);

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

  /// Số phiên tải mỗi lần trong màn lịch sử của phụ huynh.
  static const int historyPageSize = 20;
}
