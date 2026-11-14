import '../entities/question_bank.dart';
import '../repositories/repositories.dart';

enum QuestionSourceError { invalidUrl, insecureUrl }

class QuestionSourceException implements Exception {
  const QuestionSourceException(this.error);
  final QuestionSourceError error;
  @override
  String toString() => 'QuestionSourceException($error)';
}

/// Cập nhật câu hỏi từ internet; bỏ qua nếu vừa cập nhật trong [minInterval].
class SyncQuestionBankUseCase {
  SyncQuestionBankUseCase(this._bank, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final QuestionBankRepository _bank;
  final DateTime Function() _clock;

  Future<QuestionSyncResult?> call({
    Duration minInterval = Duration.zero,
  }) async {
    if (minInterval > Duration.zero) {
      final last = (await _bank.getInfo()).lastSyncedAt;
      if (last != null && _clock().difference(last) < minInterval) return null;
    }
    return _bank.sync();
  }
}

/// Phụ huynh đổi nguồn câu hỏi (chỉ chấp nhận https) rồi tải ngay.
class ChangeQuestionSourceUseCase {
  ChangeQuestionSourceUseCase(this._bank);
  final QuestionBankRepository _bank;

  Future<QuestionSyncResult> call(String? manifestUrl) async {
    final trimmed = manifestUrl?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      final uri = Uri.tryParse(trimmed);
      if (uri == null || !uri.hasAuthority) {
        throw const QuestionSourceException(QuestionSourceError.invalidUrl);
      }
      if (uri.scheme != 'https') {
        throw const QuestionSourceException(QuestionSourceError.insecureUrl);
      }
    }
    await _bank.setSource(trimmed == null || trimmed.isEmpty ? null : trimmed);
    return _bank.sync();
  }
}
