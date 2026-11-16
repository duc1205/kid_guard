import 'study_task.dart';

/// Một lần trẻ trả lời câu hỏi (lưu đủ nội dung để người lớn xem lại).
class QuestionAttempt {
  const QuestionAttempt({
    required this.questionId,
    required this.subject,
    required this.topic,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.chosenIndex,
    required this.suggestion,
    required this.answeredAt,
    this.optionOrder = const [0, 1, 2, 3],
  });

  final String questionId;
  final String subject;
  final String topic;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final int chosenIndex;
  final String suggestion;
  final DateTime answeredAt;

  /// Thứ tự đáp án trẻ đã thấy (xem [Question.optionOrder]).
  final List<int> optionOrder;

  bool get isCorrect => chosenIndex == correctIndex;
}

enum SessionEndReason {
  /// Người lớn thu hồi máy (nhập đúng mật khẩu máy).
  parentRevoked,
}

/// Nhật ký một phiên dùng máy của trẻ, từ lúc đăng ký đến lúc người lớn thu hồi.
class UsageLog {
  const UsageLog({
    required this.id,
    required this.childId,
    required this.childName,
    required this.grade,
    required this.startedAt,
    this.endedAt,
    this.lockedAt,
    this.usedTime = Duration.zero,
    this.attempts = const [],
    this.completions = const [],
  });

  final String id;
  final String childId;
  final String childName;
  final int grade;
  final DateTime startedAt;
  final DateTime? endedAt;

  /// Thời điểm máy bị khoá do trả lời sai (null nếu chưa bị khoá).
  final DateTime? lockedAt;

  /// Tổng thời gian trẻ thực sự được dùng máy (không tính lúc trả lời câu hỏi / bị khoá).
  final Duration usedTime;
  final List<QuestionAttempt> attempts;

  /// Các việc học bé đã làm xong trong phiên.
  final List<TaskCompletion> completions;

  int get correctCount => attempts.where((a) => a.isCorrect).length;
  int get wrongCount => attempts.length - correctCount;
  bool get isActive => endedAt == null;

  UsageLog copyWith({
    DateTime? endedAt,
    DateTime? lockedAt,
    Duration? usedTime,
    List<QuestionAttempt>? attempts,
    List<TaskCompletion>? completions,
  }) => UsageLog(
    id: id,
    childId: childId,
    childName: childName,
    grade: grade,
    startedAt: startedAt,
    endedAt: endedAt ?? this.endedAt,
    lockedAt: lockedAt ?? this.lockedAt,
    usedTime: usedTime ?? this.usedTime,
    attempts: attempts ?? this.attempts,
    completions: completions ?? this.completions,
  );
}
