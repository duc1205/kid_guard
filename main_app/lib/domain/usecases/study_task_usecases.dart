import '../../core/constants/app_constants.dart';
import '../../core/utils/clock.dart';
import '../entities/study_task.dart';
import '../repositories/repositories.dart';
import 'register_child.dart';

/// Khoảng [đầu ngày, đầu ngày hôm sau) theo giờ máy — "hôm nay" của việc học.
(DateTime, DateTime) dayBounds(DateTime now) {
  final start = DateTime(now.year, now.month, now.day);
  return (start, DateTime(now.year, now.month, now.day + 1));
}

/// Danh sách việc học của bé kèm trạng thái đã làm hôm nay chưa.
class GetTodayTasksUseCase {
  GetTodayTasksUseCase(this._tasks, {Clock clock = systemClock})
    : _clock = clock;

  final StudyTaskRepository _tasks;
  final Clock _clock;

  Future<List<TodayTask>> call(String childId) async {
    final (from, to) = dayBounds(_clock());
    final (tasks, done) = await (
      _tasks.getTasks(childId),
      _tasks.completedTaskIds(childId, from: from, to: to),
    ).wait;
    return [for (final t in tasks) TodayTask(t, done: done.contains(t.id))];
  }
}

/// Danh sách việc học (màn của bố mẹ).
class GetStudyTasksUseCase {
  GetStudyTasksUseCase(this._tasks);
  final StudyTaskRepository _tasks;

  Future<List<StudyTask>> call(String childId) => _tasks.getTasks(childId);
}

/// Thêm / sửa việc học. Ném [ValidationException] nếu thiếu tên việc.
class SaveStudyTaskUseCase {
  SaveStudyTaskUseCase(this._tasks, this._newId, {Clock clock = systemClock})
    : _clock = clock;

  final StudyTaskRepository _tasks;
  final String Function() _newId;
  final Clock _clock;

  Future<StudyTask> call({
    StudyTask? existing,
    required String childId,
    required String title,
    required StudyTaskKind kind,
    required Duration reward,
    Duration? duration,
  }) async {
    var name = title.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (name.isEmpty) {
      throw const ValidationException(ValidationError.taskTitleRequired);
    }
    if (name.length > AppConstants.maxTaskTitleLength) {
      name = name.substring(0, AppConstants.maxTaskTitleLength);
    }
    if (reward <= Duration.zero) throw ArgumentError.value(reward, 'reward');
    final d = kind == StudyTaskKind.timer
        ? (duration ?? AppConstants.defaultTaskDuration)
        : null;
    if (d != null && d <= Duration.zero) {
      throw ArgumentError.value(duration, 'duration');
    }

    final StudyTask task;
    if (existing != null) {
      task = StudyTask(
        id: existing.id,
        childId: existing.childId,
        title: name,
        kind: kind,
        reward: reward,
        duration: d,
        position: existing.position,
        createdAt: existing.createdAt,
      );
    } else {
      final current = await _tasks.getTasks(childId);
      final last = current.fold(-1, (m, t) => t.position > m ? t.position : m);
      task = StudyTask(
        id: _newId(),
        childId: childId,
        title: name,
        kind: kind,
        reward: reward,
        duration: d,
        position: last + 1,
        createdAt: _clock(),
      );
    }
    await _tasks.saveTask(task);
    return task;
  }
}

class DeleteStudyTaskUseCase {
  DeleteStudyTaskUseCase(this._tasks);
  final StudyTaskRepository _tasks;

  Future<void> call(String taskId) => _tasks.deleteTask(taskId);
}
