/// Trạng thái ngân hàng câu hỏi đang dùng trên máy.
class QuestionBankInfo {
  const QuestionBankInfo({
    required this.sourceUrl,
    required this.isDefaultSource,
    required this.version,
    required this.downloadedGrades,
    this.lastSyncedAt,
  });

  /// Địa chỉ manifest.json đang dùng để cập nhật câu hỏi.
  final String sourceUrl;
  final bool isDefaultSource;

  /// Phiên bản bộ câu hỏi (0 = chưa từng tải, đang dùng bộ đóng gói sẵn).
  final int version;

  /// Số lớp / bậc đang dùng câu hỏi đã tải về (còn lại dùng bộ đóng gói sẵn).
  final int downloadedGrades;
  final DateTime? lastSyncedAt;
}

enum QuestionSyncStatus { updated, upToDate, failed }

enum QuestionSyncError {
  /// Không có mạng / máy chủ lỗi / quá thời gian chờ.
  network,

  /// manifest.json sai định dạng.
  invalidManifest,

  /// File câu hỏi sai định dạng (thiếu đáp án, đáp án trùng…).
  invalidQuestions,

  /// Nội dung file không khớp mã kiểm tra trong manifest.
  checksumMismatch,
}

class QuestionSyncResult {
  const QuestionSyncResult._(this.status, {this.version, this.error});

  const QuestionSyncResult.updated(int version)
    : this._(QuestionSyncStatus.updated, version: version);
  const QuestionSyncResult.upToDate(int version)
    : this._(QuestionSyncStatus.upToDate, version: version);
  const QuestionSyncResult.failed(QuestionSyncError error)
    : this._(QuestionSyncStatus.failed, error: error);

  final QuestionSyncStatus status;
  final int? version;
  final QuestionSyncError? error;
}
