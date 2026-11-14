import '../../core/constants/app_constants.dart';
import '../../core/utils/clock.dart';
import '../entities/active_session.dart';
import '../entities/child_profile.dart';
import '../entities/usage_log.dart';
import '../repositories/repositories.dart';
import 'pick_question.dart';

/// Bắt đầu phiên: trẻ được dùng máy 15 phút.
class StartSessionUseCase {
  StartSessionUseCase(
    this._active,
    this._logs,
    this._device,
    this._newId, {
    Clock clock = systemClock,
  }) : _clock = clock;

  final ActiveSessionRepository _active;
  final UsageLogRepository _logs;
  final DeviceControlRepository _device;
  final String Function() _newId;
  final Clock _clock;

  Future<ActiveSession> call(ChildProfile child) async {
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
      endsAt: now.add(AppConstants.initialAllowance),
      segmentStartedAt: now,
    );
    await _logs.createLog(log);
    await _active.save(session);
    await _device.startTimer(session.endsAt);
    return session;
  }
}

/// Hết giờ → cộng dồn thời gian đã dùng, chọn câu hỏi, bật chế độ giữ màn hình.
/// Gọi lại nhiều lần cũng an toàn (chỉ chuyển trạng thái khi thực sự hết giờ).
class HandleTimeUpUseCase {
  HandleTimeUpUseCase(
    this._active,
    this._logs,
    this._device,
    this._pickQuestion, {
    Clock clock = systemClock,
  }) : _clock = clock;

  final ActiveSessionRepository _active;
  final UsageLogRepository _logs;
  final DeviceControlRepository _device;
  final PickQuestionUseCase _pickQuestion;
  final Clock _clock;

  Future<ActiveSession> call(ActiveSession session) async {
    if (session.status != GuardStatus.running ||
        _clock().isBefore(session.endsAt)) {
      return session;
    }
    await _addSegment(_logs, session, until: session.endsAt);
    final question = await _pickQuestion(
      childId: session.child.id,
      grade: session.child.grade,
    );
    final next = session.copyWith(
      status: GuardStatus.quiz,
      currentQuestion: question,
      clearSegment: true,
    );
    await _active.save(next);
    await _device.setGuard(true);
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
