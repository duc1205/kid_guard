import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/utils/clock.dart';
import '../../domain/entities/active_session.dart';
import '../../domain/entities/child_profile.dart';
import '../../domain/entities/study_task.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/register_child.dart';
import '../../domain/usecases/session_usecases.dart';
import '../../domain/usecases/study_task_usecases.dart';

/// Hỏi người lớn (mã PIN phụ huynh, hoặc mật khẩu máy nếu được phép) — do
/// giao diện cung cấp vì cần hiện hộp thoại.
typedef ParentAuthorizer = Future<ParentAuthResult> Function();

/// Máy trạng thái của phiên dùng máy:
/// running → tasks → (việc bố mẹ duyệt | taskTimer → running)
///                 → quiz → (running | review → locked).
/// Chưa có việc học nào: running → quiz như trước.
class GuardController extends ChangeNotifier {
  GuardController({
    required ActiveSessionRepository activeSessions,
    required ChildRepository children,
    required DeviceControlRepository device,
    required RegisterChildUseCase registerChild,
    required StartSessionUseCase startSession,
    required HandleTimeUpUseCase handleTimeUp,
    required SubmitAnswerUseCase submitAnswer,
    required AcknowledgeWrongAnswerUseCase acknowledgeWrong,
    required RevokeSessionUseCase revokeSession,
    required GetTodayTasksUseCase todayTasks,
    required ChooseQuizUseCase chooseQuiz,
    required StartTimerTaskUseCase startTimerTask,
    required CancelTimerTaskUseCase cancelTimerTask,
    required CompleteTaskUseCase completeTask,
    Clock clock = systemClock,
  }) : _activeSessions = activeSessions,
       _children = children,
       _device = device,
       _registerChild = registerChild,
       _startSession = startSession,
       _handleTimeUp = handleTimeUp,
       _submitAnswer = submitAnswer,
       _acknowledgeWrong = acknowledgeWrong,
       _revokeSession = revokeSession,
       _todayTasks = todayTasks,
       _chooseQuiz = chooseQuiz,
       _startTimerTask = startTimerTask,
       _cancelTimerTask = cancelTimerTask,
       _completeTask = completeTask,
       _clock = clock;

  final ActiveSessionRepository _activeSessions;
  final ChildRepository _children;
  final DeviceControlRepository _device;
  final RegisterChildUseCase _registerChild;
  final StartSessionUseCase _startSession;
  final HandleTimeUpUseCase _handleTimeUp;
  final SubmitAnswerUseCase _submitAnswer;
  final AcknowledgeWrongAnswerUseCase _acknowledgeWrong;
  final RevokeSessionUseCase _revokeSession;
  final GetTodayTasksUseCase _todayTasks;
  final ChooseQuizUseCase _chooseQuiz;
  final StartTimerTaskUseCase _startTimerTask;
  final CancelTimerTaskUseCase _cancelTimerTask;
  final CompleteTaskUseCase _completeTask;
  final Clock _clock;

  Timer? _ticker;
  bool _transitioning = false;

  bool loading = true;
  ActiveSession? session;

  /// Chi tiết lỗi kỹ thuật (không dịch); giao diện tự hiện câu thông báo theo ngôn ngữ máy.
  String? error;

  /// Nhịp đồng hồ 1 giây/lần. Tách riêng khỏi [notifyListeners] để mỗi giây chỉ
  /// widget đếm ngược được vẽ lại, không phải cả màn hình.
  final ValueNotifier<DateTime> clockTick = ValueNotifier(DateTime.now());

  Duration get remaining =>
      session?.remaining(clockTick.value) ?? Duration.zero;

  Future<void> init() async {
    try {
      session = await _activeSessions.get();
      final s = session;
      if (s != null) {
        // Đồng bộ lại phía native (vd. sau khi app bị kill / máy khởi động lại).
        await _device.startTimer(s.endsAt);
        if (s.isGuarded) await _device.setGuard(true);
      }
    } catch (e) {
      error = '$e';
    }
    loading = false;
    await _checkTimeUp();
    _changed();
  }

  /// Gọi khi trạng thái phiên đổi: vẽ lại màn hình và bật/tắt timer.
  /// Timer chỉ chạy khi đang đếm ngược (dùng máy / việc hẹn giờ) — lúc khác
  /// không tốn CPU/pin.
  void _changed() {
    clockTick.value = _clock();
    final status = session?.status;
    final running =
        status == GuardStatus.running || status == GuardStatus.taskTimer;
    if (running && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        clockTick.value = _clock();
        _checkTimeUp();
      });
    } else if (!running) {
      _ticker?.cancel();
      _ticker = null;
    }
    notifyListeners();
  }

  /// Gọi khi app quay lại foreground (iOS tạm dừng timer khi ở nền).
  Future<void> onResumed() async {
    clockTick.value = _clock();
    await _checkTimeUp();
  }

  Future<void> _checkTimeUp() async {
    final s = session;
    if (s == null || _transitioning) return;
    final now = _clock();
    final Future<ActiveSession> Function() step;
    if (s.status == GuardStatus.running && !now.isBefore(s.endsAt)) {
      step = () => _handleTimeUp(s);
    } else if (s.status == GuardStatus.taskTimer &&
        s.currentTask != null &&
        !now.isBefore(s.taskEndsAt!)) {
      // Xong việc hẹn giờ → tự cộng phút, bé không phải bấm gì.
      step = () => _completeTask(s, s.currentTask!);
    } else {
      return;
    }
    _transitioning = true;
    try {
      session = await step();
      error = null;
    } catch (e) {
      error = '$e';
    } finally {
      _transitioning = false;
      _changed();
    }
  }

  /// Ném [ValidationException] nếu thông tin chưa hợp lệ.
  Future<void> startForChild({
    required String name,
    required DateTime? dateOfBirth,
    required int? grade,
  }) async {
    final child = await _registerChild(
      name: name,
      dateOfBirth: dateOfBirth,
      grade: grade,
    );
    session = await _startSession(child);
    _changed();
  }

  /// Các bé đã từng đăng ký trên máy — để lần sau chỉ cần chọn tên.
  Future<List<ChildProfile>> savedChildren() => _children.getChildren();

  /// Bắt đầu phiên cho bé đã lưu (không cần nhập lại thông tin).
  Future<void> startForSavedChild(ChildProfile child) async {
    session = await _startSession(child);
    _changed();
  }

  /// Trả về true nếu trả lời đúng.
  Future<bool> answer(int chosenIndex) async {
    final s = session;
    if (s == null || s.status != GuardStatus.quiz) return false;
    final correct = s.currentQuestion!.isCorrect(chosenIndex);
    session = await _submitAnswer(s, chosenIndex);
    _changed();
    return correct;
  }

  Future<void> acknowledgeWrongAnswer() async {
    final s = session;
    if (s == null) return;
    session = await _acknowledgeWrong(s);
    _changed();
  }

  /// Việc học của bé hôm nay (màn chọn việc).
  Future<List<TodayTask>> todayTasks() async {
    final s = session;
    if (s == null) return const [];
    return _todayTasks(s.child.id);
  }

  /// Bé chọn trả lời câu hỏi thay vì làm việc học.
  Future<void> chooseQuiz() async {
    final s = session;
    if (s == null || _transitioning) return;
    _transitioning = true;
    try {
      session = await _chooseQuiz(s);
      error = null;
    } catch (e) {
      error = '$e';
    } finally {
      _transitioning = false;
      _changed();
    }
  }

  Future<void> startTimerTask(StudyTask task) async {
    final s = session;
    if (s == null) return;
    session = await _startTimerTask(s, task);
    _changed();
  }

  Future<void> cancelTimerTask() async {
    final s = session;
    if (s == null) return;
    session = await _cancelTimerTask(s);
    _changed();
  }

  /// Bố mẹ duyệt việc bé đã làm: [authorize] (mã PIN phụ huynh) đúng → bé
  /// được cộng phút.
  Future<ParentAuthResult> approveTask(
    StudyTask task, {
    required ParentAuthorizer authorize,
  }) async {
    final s = session;
    if (s == null || s.status != GuardStatus.tasks) {
      return ParentAuthResult.failed;
    }
    final result = await authorize();
    if (result == ParentAuthResult.success) {
      session = await _completeTask(s, task);
      _changed();
    } else {
      await _device.setGuard(true);
    }
    return result;
  }

  Future<void> useOtherApps() => _device.moveToBackground();

  /// Người lớn thu hồi: [authorize] (mã PIN phụ huynh) phải đúng.
  Future<ParentAuthResult> parentRevoke({
    required ParentAuthorizer authorize,
  }) async {
    final s = session;
    if (s == null) return ParentAuthResult.success;
    final result = await authorize();
    if (result == ParentAuthResult.success) {
      await _revokeSession(s);
      session = null;
      _changed();
    } else if (s.isGuarded) {
      // Xác thực thất bại → giữ nguyên khoá.
      await _device.setGuard(true);
    }
    return result;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    clockTick.dispose();
    super.dispose();
  }
}
