import 'dart:math';

import '../../core/constants/app_constants.dart';
import '../entities/question.dart';
import '../repositories/repositories.dart';

/// Chọn ngẫu nhiên 1 câu hỏi trong phạm vi lớp của trẻ (tất cả môn học +
/// câu hỏi mở + kiến thức xã hội), tránh lặp lại các câu trẻ vừa được hỏi.
class PickQuestionUseCase {
  PickQuestionUseCase(this._questions, this._logs, {Random? random})
    : _random = random ?? Random();

  final QuestionRepository _questions;
  final UsageLogRepository _logs;
  final Random _random;

  Future<Question> call({required String childId, required int grade}) async {
    final pool = await _questions.getQuestionsForGrade(grade);
    if (pool.isEmpty) {
      throw StateError('No questions available for grade $grade');
    }
    final recent = (await _logs.recentQuestionIds(
      childId,
      limit: AppConstants.recentQuestionWindow,
    )).toSet();
    var candidates = pool.where((q) => !recent.contains(q.id)).toList();
    if (candidates.isEmpty) candidates = pool;
    return candidates[_random.nextInt(candidates.length)].shuffled(_random);
  }
}
