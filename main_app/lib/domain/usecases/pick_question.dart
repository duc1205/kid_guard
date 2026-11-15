import 'dart:math';

import '../../core/constants/app_constants.dart';
import '../../core/utils/clock.dart';
import '../entities/question.dart';
import '../repositories/repositories.dart';

/// Chọn 1 câu hỏi trong phạm vi lớp của trẻ (tất cả môn học + câu hỏi mở +
/// kiến thức xã hội):
/// 1. Chỉ hỏi phần đã học: đang học kỳ 1 thì chưa hỏi câu đánh dấu `term: 2`.
/// 2. Tránh lặp lại các câu trẻ vừa được hỏi.
/// 3. Thỉnh thoảng ([weakTopicChance]) ưu tiên chủ đề trẻ hay trả lời sai.
/// Bước nào lọc hết câu thì bỏ qua bước đó (trẻ luôn có câu để trả lời).
class PickQuestionUseCase {
  PickQuestionUseCase(
    this._questions,
    this._logs, {
    Random? random,
    Clock? clock,
  }) : _random = random ?? Random(),
       _clock = clock ?? DateTime.now;

  final QuestionRepository _questions;
  final UsageLogRepository _logs;
  final Random _random;
  final Clock _clock;

  /// Tỉ lệ lượt hỏi ưu tiên ôn chủ đề yếu (phần còn lại chọn ngẫu nhiên để
  /// trẻ không chỉ gặp mãi một chủ đề).
  static const weakTopicChance = 0.4;

  /// Học kỳ theo năm học phổ thông Việt Nam: HK1 khoảng tháng 9 – tháng 1,
  /// HK2 khoảng tháng 2 – tháng 5. Nghỉ hè → null (hỏi mọi câu, để ôn tập).
  static int? currentTerm(DateTime now) => switch (now.month) {
    9 || 10 || 11 || 12 || 1 => 1,
    2 || 3 || 4 || 5 => 2,
    _ => null,
  };

  Future<Question> call({required String childId, required int grade}) async {
    final pool = await _questions.getQuestionsForGrade(grade);
    if (pool.isEmpty) {
      throw StateError('No questions available for grade $grade');
    }
    final term = currentTerm(_clock());
    var candidates = _prefer(
      pool,
      (q) => term == null || q.term == null || q.term! <= term,
    );

    final recent = (await _logs.recentQuestionIds(
      childId,
      limit: AppConstants.recentQuestionWindow,
    )).toSet();
    candidates = _prefer(candidates, (q) => !recent.contains(q.id));

    if (_random.nextDouble() < weakTopicChance) {
      final weak = {
        for (final w in await _logs.getWeakTopics(childId, limit: 5))
          (w.subject, w.topic),
      };
      if (weak.isNotEmpty) {
        candidates = _prefer(
          candidates,
          (q) => weak.contains((q.subject, q.topic)),
        );
      }
    }
    return candidates[_random.nextInt(candidates.length)].shuffled(_random);
  }

  /// Giữ các câu thoả [test]; nếu không còn câu nào thì giữ nguyên danh sách.
  static List<Question> _prefer(
    List<Question> list,
    bool Function(Question q) test,
  ) {
    final filtered = list.where(test).toList();
    return filtered.isEmpty ? list : filtered;
  }
}
