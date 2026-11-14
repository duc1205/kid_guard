/// Thống kê tổng hợp của một trẻ (tính bằng SQL, không cần tải toàn bộ lịch sử).
class ChildUsageStats {
  const ChildUsageStats({
    required this.childId,
    this.totalUsed = Duration.zero,
    this.sessionCount = 0,
    this.correct = 0,
    this.wrong = 0,
    this.lastUsedAt,
  });

  final String childId;
  final Duration totalUsed;
  final int sessionCount;
  final int correct;
  final int wrong;
  final DateTime? lastUsedAt;
}

/// Một phần kiến thức trẻ hay trả lời sai.
class WeakTopic {
  const WeakTopic({
    required this.subject,
    required this.topic,
    required this.wrongCount,
  });

  final String subject;
  final String topic;
  final int wrongCount;
}
