import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/question_bank.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/question_bank_usecases.dart';

/// Màn "Nguồn câu hỏi" của phụ huynh: xem phiên bản, cập nhật, đổi nguồn.
class QuestionBankController extends ChangeNotifier {
  QuestionBankController({
    required QuestionBankRepository bank,
    required SyncQuestionBankUseCase sync,
    required ChangeQuestionSourceUseCase changeSource,
  }) : _bank = bank,
       _sync = sync,
       _changeSource = changeSource;

  final QuestionBankRepository _bank;
  final SyncQuestionBankUseCase _sync;
  final ChangeQuestionSourceUseCase _changeSource;

  QuestionBankInfo? info;
  bool busy = false;
  QuestionSyncResult? lastResult;

  Future<void> load() async {
    info = await _bank.getInfo();
    notifyListeners();
  }

  Future<QuestionSyncResult> syncNow() => _run(() async => (await _sync())!);

  /// Tự kiểm tra ở nền khi mở / quay lại app (bỏ qua nếu vừa kiểm tra).
  /// Lỗi mạng thì vẫn dùng bản câu hỏi đang có.
  Future<void> syncInBackground() async {
    try {
      final r = await _sync(minInterval: AppConstants.questionSyncInterval);
      if (r != null) debugPrint('Question sync: ${r.status}');
    } catch (e) {
      debugPrint('Question sync failed: $e');
    }
  }

  /// Ném [QuestionSourceException] nếu địa chỉ không hợp lệ.
  Future<QuestionSyncResult> changeSource(String? manifestUrl) =>
      _run(() => _changeSource(manifestUrl));

  Future<QuestionSyncResult> _run(
    Future<QuestionSyncResult> Function() action,
  ) async {
    busy = true;
    notifyListeners();
    try {
      return lastResult = await action();
    } finally {
      busy = false;
      info = await _bank.getInfo();
      notifyListeners();
    }
  }
}
