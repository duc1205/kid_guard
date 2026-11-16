import '../../core/constants/app_constants.dart';
import '../../core/utils/clock.dart';
import '../entities/active_session.dart';
import '../entities/child_profile.dart';
import '../entities/study_task.dart';
import '../entities/usage_log.dart';
import '../repositories/repositories.dart';
import 'pick_question.dart';
import 'study_task_usecases.dart';

/// Bắt đầu phiên: trẻ được dùng máy theo thời gian người lớn đã đặt (mặc định 15 phút).
class StartSessionUseCase {
  StartSessionUseCase(
    this._active,
    this._logs,
    this._device,
    this._settings,
    this._newId, {
    Clock clock = systemClock,
  }) : _clock = clock;

  final ActiveSessionRepository _active;
  final SettingsRepository _settings;
  final UsageLogRepository _logs;
  final DeviceControlRepository _device;
  final String Function() _newId;
  final Clock _clock;

  Future<ActiveSession> call(ChildProfile child) async {
    final allowance = await _settings.getInitialAllowance();
    final now = _clock();
    final log = UsageLog(
      id: _newId(),
      childId: child.id,
      childName: child.name,
      grade: child.grade,
      startedAt: now,
    );
    final session = ActiveSession(
      logId: log.id,
      child: child,
      status: GuardStatus.running,
      endsAt: now.add(allowance),
      segmentStartedAt: now,
    );
    await _logs.createLog(log);
    await _active.save(session);
    await _device.startTimer(session.endsAt);
    return session;
  }
}

/// Hết giờ → cộng dồn thời gian đã dùng, bật chế độ giữ màn hình, rồi:
/// - còn việc học chưa làm hôm nay → bé chọn việc ([GuardStatus.tasks]);
/// - chưa có việc nào / đã làm hết → hỏi câu hỏi như trước ([GuardStatus.quiz]).
/// Gọi lại nhiều lần cũng an toàn (chỉ chuyển trạng thái khi thực sự hết giờ).
class HandleTimeUpUseCase {
  HandleTimeUpUseCase(
    this._active,
    this._logs,
    this._device,
    this._pickQuestion,
    this._todayTasks, {
    Clock clock = systemClock,
  }) : _clock = clock;

  final ActiveSessionRepository _active;
  final UsageLogRepository _logs;
  final DeviceControlRepository _device;
  final PickQuestionUseCase _pickQuestion;
  final GetTodayTasksUseCase _todayTasks;
  final Clock _clock;

  Future<ActiveSession> call(ActiveSession session) async {
    if (session.status != GuardStatus.running ||
        _clock().isBefore(session.endsAt)) {
      return session;
    }
    await _addSegment(_logs, session, until: session.endsAt);
    final today = await _todayTasks(session.child.id);
    final ActiveSession next;
    if (today.any((t) => !t.done)) {
      next = session.copyWith(status: GuardStatus.tasks, clearSegment: true);
    } else {
      final question = await _pickQuestion(
        childId: session.child.id,
        grade: session.child.grade,
      );
      next = session.copyWith(
        status: GuardStatus.quiz,
        currentQuestion: question,
        clearSegment: true,
      );
    }
    await _active.save(next);
    await _device.setGuard(true);
    return next;
  }
}

/// Ở màn việc học, bé chọn trả lời câu hỏi (luật như cũ: đúng +5 phút, sai khoá máy).
class ChooseQuizUseCase {
  ChooseQuizUseCase(this._active, this._pickQuestion);

  final ActiveSessionRepository _active;
  final PickQuestionUseCase _pickQuestion;

  Future<ActiveSession> call(ActiveSession session) async {
    if (session.status != GuardStatus.tasks) return session;
    final question = await _pickQuestion(
      childId: session.child.id,
      grade: session.child.grade,
    );
    final next = session.copyWith(
      status: GuardStatus.quiz,
      currentQuestion: question,
    );
    await _active.save(next);
    return next;
  }
}

/// Bé bắt đầu việc hẹn giờ: máy vẫn khoá, đếm ngược tới lúc xong việc.
class StartTimerTaskUseCase {
  StartTimerTaskUseCase(this._active, {Clock clock = systemClock})
    : _clock = clock;

  final ActiveSessionRepository _active;
  final Clock _clock;

  Future<ActiveSession> call(ActiveSession session, StudyTask task) async {
    final d = task.duration;
    if (session.status != GuardStatus.tasks ||
        task.kind != StudyTaskKind.timer ||
        d == null) {
      return session;
    }
    final next = session.copyWith(
      status: GuardStatus.taskTimer,
      currentTask: task,
      taskEndsAt: _clock().add(d),
    );
    await _active.save(next);
    return next;
  }
}

/// Bé dừng việc hẹn giờ giữa chừng → quay lại danh sách việc (không được thưởng).
class CancelTimerTaskUseCase {
  CancelTimerTaskUseCase(this._active);
  final ActiveSessionRepository _active;

  Future<ActiveSession> call(ActiveSession session) async {
    if (session.status != GuardStatus.taskTimer) return session;
    final next = session.copyWith(status: GuardStatus.tasks, clearTask: true);
    await _active.save(next);
    return next;
  }
}

/// Bé xong việc → ghi lại, thêm [StudyTask.reward] phút dùng máy.
/// - Việc bố mẹ duyệt: gọi sau khi bố mẹ đã xác thực (ở màn việc học).
/// - Việc hẹn giờ: chỉ được khi đã hết thời gian đếm ngược.
/// Mỗi việc chỉ tính 1 lần mỗi ngày.
class CompleteTaskUseCase {
  CompleteTaskUseCase(
    this._active,
    this._tasks,
    this._todayTasks,
    this._device, {
    Clock clock = systemClock,
  }) : _clock = clock;

  final ActiveSessionRepository _active;
  final StudyTaskRepository _tasks;
  final GetTodayTasksUseCase _todayTasks;
  final DeviceControlRepository _device;
  final Clock _clock;

  Future<ActiveSession> call(ActiveSession session, StudyTask task) async {
    final now = _clock();
    final allowed = switch (task.kind) {
      StudyTaskKind.check => session.status == GuardStatus.tasks,
      StudyTaskKind.timer =>
        session.status == GuardStatus.taskTimer &&
            session.currentTask?.id == task.id &&
            !now.isBefore(session.taskEndsAt!),
    };
    if (!allowed) return session;
    final today = await _todayTasks(session.child.id);
    if (today.any((t) => t.task.id == task.id && t.done)) {
      // Đã tính hôm nay rồi → không thưởng thêm, quay lại danh sách.
      final back = session.copyWith(status: GuardStatus.tasks, clearTask: true);
      await _active.save(back);
      return back;
    }

    await _tasks.addCompletion(
      session.logId,
      session.child.id,
      TaskCompletion(
        taskId: task.id,
        title: task.title,
        kind: task.kind,
        reward: task.reward,
        completedAt: now,
      ),
    );
    final next = session.copyWith(
      status: GuardStatus.running,
      endsAt: now.add(task.reward),
      segmentStartedAt: now,
      clearTask: true,
      clearQuestion: true,
    );
    await _active.save(next);
    await _device.startTimer(next.endsAt);
    await _device.setGuard(false);
    return next;
  }
}

/// Trẻ trả lời: đúng → thêm 5 phút; sai → chuyển sang màn gợi ý ôn tập.
class SubmitAnswerUseCase {
  SubmitAnswerUseCase(
    this._active,
    this._logs,
    this._device, {
    Clock clock = systemClock,
  }) : _clock = clock;

  final ActiveSessionRepository _active;
  final UsageLogRepository _logs;
  final DeviceControlRepository _device;
  final Clock _clock;

  Future<ActiveSession> call(ActiveSession session, int chosenIndex) async {
    final q = session.currentQuestion;
    if (session.status != GuardStatus.quiz || q == null) return session;
    final now = _clock();

    await _logs.addAttempt(
      session.logId,
      session.child.id,
      QuestionAttempt(
        questionId: q.id,
        subject: q.subject,
        topic: q.topic,
        questionText: q.text,
        options: q.options,
        optionOrder: q.optionOrder,
        correctIndex: q.answerIndex,
        chosenIndex: chosenIndex,
        suggestion: q.suggestion,
        answeredAt: now,
      ),
    );

    if (q.isCorrect(chosenIndex)) {
      final next = session.copyWith(
        status: GuardStatus.running,
        endsAt: now.add(AppConstants.bonusPerCorrectAnswer),
        segmentStartedAt: now,
        clearQuestion: true,
      );
      await _active.save(next);
      await _device.startTimer(next.endsAt);
      await _device.setGuard(false);
      return next;
    }

    final next = session.copyWith(
      status: GuardStatus.review,
      chosenIndex: chosenIndex,
    );
    await _active.save(next);
    return next;
  }
}

/// Trẻ bấm OK sau khi đọc gợi ý → khoá máy.
class AcknowledgeWrongAnswerUseCase {
  AcknowledgeWrongAnswerUseCase(
    this._active,
    this._logs,
    this._device, {
    Clock clock = systemClock,
  }) : _clock = clock;

  final ActiveSessionRepository _active;
  final UsageLogRepository _logs;
  final DeviceControlRepository _device;
  final Clock _clock;

  Future<ActiveSession> call(ActiveSession session) async {
    if (session.status != GuardStatus.review) return session;
    await _logs.markLocked(session.logId, _clock());
    final next = session.copyWith(
      status: GuardStatus.locked,
      clearQuestion: true,
    );
    await _active.save(next);
    await _device.setGuard(true);
    return next;
  }
}

/// Người lớn thu hồi máy (đã xác thực) → kết thúc phiên, app ngừng kiểm soát.
class RevokeSessionUseCase {
  RevokeSessionUseCase(
    this._active,
    this._logs,
    this._device, {
    Clock clock = systemClock,
  }) : _clock = clock;

  final ActiveSessionRepository _active;
  final UsageLogRepository _logs;
  final DeviceControlRepository _device;
  final Clock _clock;

  Future<void> call(ActiveSession session) async {
    final now = _clock();
    if (session.status == GuardStatus.running) {
      final until = now.isBefore(session.endsAt) ? now : session.endsAt;
      await _addSegment(_logs, session, until: until);
    }
    await _logs.markEnded(session.logId, now);
    await _active.clear();
    await _device.stop();
  }
}

/// Dọn nhật ký cũ hơn [AppConstants.logRetention] — chạy mỗi lần mở app.
class PruneOldLogsUseCase {
  PruneOldLogsUseCase(this._logs, {Clock clock = systemClock}) : _clock = clock;

  final UsageLogRepository _logs;
  final Clock _clock;

  Future<int> call() =>
      _logs.deleteEndedBefore(_clock().subtract(AppConstants.logRetention));
}

Future<void> _addSegment(
  UsageLogRepository logs,
  ActiveSession session, {
  required DateTime until,
}) async {
  final start = session.segmentStartedAt;
  if (start == null) return;
  final used = until.difference(start);
  if (used > Duration.zero) await logs.addUsedTime(session.logId, used);
}
