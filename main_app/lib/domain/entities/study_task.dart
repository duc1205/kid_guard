/// Cách xác nhận một việc học đã xong.
enum StudyTaskKind {
  /// Bé báo xong → bố mẹ nhập mật khẩu máy để duyệt.
  check,

  /// Đếm ngược trên màn khoá (máy vẫn khoá); hết giờ là xong.
  timer,
}

/// Một việc học hằng ngày do bố mẹ đặt cho bé. Làm xong → được thêm [reward]
/// phút dùng máy. Mỗi việc chỉ tính 1 lần mỗi ngày.
class StudyTask {
  const StudyTask({
    required this.id,
    required this.childId,
    required this.title,
    required this.kind,
    required this.reward,
    this.duration,
    this.position = 0,
    required this.createdAt,
  });

  final String id;
  final String childId;
  final String title;
  final StudyTaskKind kind;

  /// Thời gian dùng máy được thêm khi xong việc.
  final Duration reward;

  /// Chỉ với [StudyTaskKind.timer]: thời gian phải làm.
  final Duration? duration;

  /// Thứ tự hiển thị (nhỏ trước).
  final int position;
  final DateTime createdAt;

  StudyTask copyWith({
    String? title,
    StudyTaskKind? kind,
    Duration? reward,
    Duration? duration,
    int? position,
  }) {
    final k = kind ?? this.kind;
    return StudyTask(
      id: id,
      childId: childId,
      title: title ?? this.title,
      kind: k,
      reward: reward ?? this.reward,
      duration: k == StudyTaskKind.timer ? duration ?? this.duration : null,
      position: position ?? this.position,
      createdAt: createdAt,
    );
  }
}

/// Việc học kèm trạng thái hôm nay.
class TodayTask {
  const TodayTask(this.task, {required this.done});
  final StudyTask task;
  final bool done;
}

/// Một lần bé làm xong việc (lưu tên + phần thưởng lúc đó để lịch sử vẫn đúng
/// khi bố mẹ sửa / xoá việc).
class TaskCompletion {
  const TaskCompletion({
    required this.taskId,
    required this.title,
    required this.kind,
    required this.reward,
    required this.completedAt,
  });

  final String taskId;
  final String title;
  final StudyTaskKind kind;
  final Duration reward;
  final DateTime completedAt;
}
