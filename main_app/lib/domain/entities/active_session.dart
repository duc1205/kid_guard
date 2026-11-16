import 'child_profile.dart';
import 'question.dart';
import 'study_task.dart';

enum GuardStatus {
  /// Trẻ đang được dùng máy, đếm ngược tới [ActiveSession.endsAt].
  running,

  /// Hết giờ: bé chọn một việc học (hoặc trả lời câu hỏi) để được dùng tiếp.
  tasks,

  /// Bé đang làm việc học hẹn giờ: đếm ngược tới [ActiveSession.taskEndsAt].
  taskTimer,

  /// Bắt buộc trả lời câu hỏi (bé chọn, hoặc chưa có việc học nào).
  quiz,

  /// Vừa trả lời sai: hiển thị gợi ý, trẻ phải bấm OK.
  review,

  /// Máy bị khoá, chỉ người lớn mở được.
  locked,
}

/// Trạng thái phiên đang diễn ra — được lưu lại để khôi phục khi app bị tắt/mở lại.
class ActiveSession {
  const ActiveSession({
    required this.logId,
    required this.child,
    required this.status,
    required this.endsAt,
    this.segmentStartedAt,
    this.currentQuestion,
    this.chosenIndex,
    this.currentTask,
    this.taskEndsAt,
  });

  final String logId;
  final ChildProfile child;
  final GuardStatus status;

  /// Thời điểm hết giờ của lượt dùng hiện tại (chỉ có ý nghĩa khi [status] = running).
  final DateTime endsAt;

  /// Bắt đầu lượt dùng hiện tại — để cộng dồn thời gian sử dụng thực tế.
  final DateTime? segmentStartedAt;

  /// Câu hỏi đang hỏi (quiz) hoặc vừa trả lời sai (review). Lưu lại để trẻ
  /// không thể tắt app mở lại nhằm đổi câu hỏi.
  final Question? currentQuestion;
  final int? chosenIndex;

  /// Việc hẹn giờ đang làm ([GuardStatus.taskTimer]) và lúc làm xong — lưu lại
  /// để tắt app mở lại không bị tính lại từ đầu.
  final StudyTask? currentTask;
  final DateTime? taskEndsAt;

  bool get isGuarded => status != GuardStatus.running;

  Duration remaining(DateTime now) {
    final d = endsAt.difference(now);
    return d.isNegative ? Duration.zero : d;
  }

  ActiveSession copyWith({
    GuardStatus? status,
    DateTime? endsAt,
    DateTime? segmentStartedAt,
    Question? currentQuestion,
    int? chosenIndex,
    StudyTask? currentTask,
    DateTime? taskEndsAt,
    bool clearSegment = false,
    bool clearQuestion = false,
    bool clearTask = false,
  }) => ActiveSession(
    logId: logId,
    child: child,
    status: status ?? this.status,
    endsAt: endsAt ?? this.endsAt,
    segmentStartedAt: clearSegment
        ? null
        : segmentStartedAt ?? this.segmentStartedAt,
    currentQuestion: clearQuestion
        ? null
        : currentQuestion ?? this.currentQuestion,
    chosenIndex: clearQuestion ? null : chosenIndex ?? this.chosenIndex,
    currentTask: clearTask ? null : currentTask ?? this.currentTask,
    taskEndsAt: clearTask ? null : taskEndsAt ?? this.taskEndsAt,
  );
}
