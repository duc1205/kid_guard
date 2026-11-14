import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/utils/clock.dart';
import '../../domain/entities/active_session.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/parent_usecases.dart';
import '../../domain/usecases/register_child.dart';
import '../../domain/usecases/session_usecases.dart';

/// Máy trạng thái của phiên dùng máy: running → quiz → (running | review → locked).
class GuardController extends ChangeNotifier {
  GuardController({
    required ActiveSessionRepository activeSessions,
    required DeviceControlRepository device,
    required ParentAuthRepository parentAuth,
    required RegisterChildUseCase registerChild,
    required StartSessionUseCase startSession,
    required HandleTimeUpUseCase handleTimeUp,
    required SubmitAnswerUseCase submitAnswer,
    required AcknowledgeWrongAnswerUseCase acknowledgeWrong,
    required RevokeSessionUseCase revokeSession,
    required AuthenticateParentUseCase authenticateParent,
    Clock clock = systemClock,
  }) : _activeSessions = activeSessions,
       _device = device,
       _parentAuth = parentAuth,
       _registerChild = registerChild,
       _startSession = startSession,
       _handleTimeUp = handleTimeUp,
       _submitAnswer = submitAnswer,
       _acknowledgeWrong = acknowledgeWrong,
       _revokeSession = revokeSession,
       _authenticateParent = authenticateParent,
       _clock = clock;

  final ActiveSessionRepository _activeSessions;
  final DeviceControlRepository _device;
  final ParentAuthRepository _parentAuth;
  final RegisterChildUseCase _registerChild;
  final StartSessionUseCase _startSession;
  final HandleTimeUpUseCase _handleTimeUp;
  final SubmitAnswerUseCase _submitAnswer;
  final AcknowledgeWrongAnswerUseCase _acknowledgeWrong;
  final RevokeSessionUseCase _revokeSession;
  final AuthenticateParentUseCase _authenticateParent;
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
  /// Timer chỉ chạy khi trẻ đang dùng máy (running) — lúc khác không tốn CPU/pin.
  void _changed() {
    clockTick.value = _clock();
    final running = session?.status == GuardStatus.running;
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
    if (s == null || s.status != GuardStatus.running || _transitioning) return;
    if (_clock().isBefore(s.endsAt)) return;
    _transitioning = true;
    try {
      session = await _handleTimeUp(s);
      error = null;
    } catch (e) {
      error = '$e';
    } finally {
      _transitioning = false;
      _changed();
    }
  }

  /// Kiểm tra máy đã cài khoá màn hình chưa (bắt buộc để người lớn thoát được).
  Future<bool> isParentLockAvailable() => _parentAuth.isAvailable();

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

  Future<void> useOtherApps() => _device.moveToBackground();

  /// Người lớn thu hồi: phải nhập đúng mật khẩu máy.
  /// [reason] là câu hiển thị trên hộp thoại xác thực của hệ thống (đã dịch).
  Future<ParentAuthResult> parentRevoke({required String reason}) async {
    final s = session;
    if (s == null) return ParentAuthResult.success;
    final result = await _authenticateParent(reason);
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
