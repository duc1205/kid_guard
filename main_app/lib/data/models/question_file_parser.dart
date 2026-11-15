import 'dart:convert';

import '../../domain/entities/question.dart';
import 'json_mappers.dart';

/// Đọc + kiểm tra một file grade_N.json. Dùng cho cả bộ đóng gói sẵn và bộ tải
/// từ internet: file sai định dạng bị từ chối toàn bộ (ném [FormatException])
/// để không bao giờ hiện câu hỏi hỏng — trả lời "sai" là khoá máy.
///
/// Trường tuỳ chọn (app cũ bỏ qua): `difficulty` 1–3, `term` 1–2,
/// `status` (`draft` | `ai-checked` | `teacher-reviewed`). Câu `draft` bị bỏ qua.
/// Luật chất lượng đầy đủ: kid_guard_question/scripts/check_questions.py.
class QuestionFileParser {
  const QuestionFileParser._();

  /// Đủ để không lặp câu liên tục.
  static const minQuestions = 5;

  static const statuses = {'draft', 'ai-checked', 'teacher-reviewed'};

  static bool _optionalInt(Object? v, int min, int max) =>
      v == null || (v is int && v >= min && v <= max);

  static List<Question> parse(String raw, int grade) {
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      throw const FormatException('not valid JSON');
    }
    if (decoded is! List) throw const FormatException('root is not a list');

    final ids = <String>{};
    final result = <Question>[];
    for (final item in decoded) {
      if (item is! Map) {
        throw const FormatException('question is not an object');
      }
      final j = Map<String, dynamic>.from(item);
      final status = j['status'] ?? 'ai-checked';
      if (!statuses.contains(status) ||
          !_optionalInt(j['difficulty'], 1, 3) ||
          !_optionalInt(j['term'], 1, 2)) {
        throw FormatException('question ${j['id']} has invalid metadata');
      }
      final Question q;
      try {
        q = QuestionMapper.fromAsset(j, grade);
      } catch (_) {
        throw FormatException('question ${j['id']} has missing/invalid fields');
      }
      final ok =
          q.id.trim().isNotEmpty &&
          ids.add(q.id) &&
          q.text.trim().isNotEmpty &&
          q.suggestion.trim().isNotEmpty &&
          q.options.length == 4 &&
          q.options.every((o) => o.trim().isNotEmpty) &&
          q.options.toSet().length == 4 &&
          q.answerIndex >= 0 &&
          q.answerIndex < 4;
      if (!ok) throw FormatException('question ${q.id} is invalid');
      // Câu nháp: vẫn kiểm tra (id không được trùng) nhưng không đưa cho trẻ.
      if (status != 'draft') result.add(q);
    }
    if (result.length < minQuestions) {
      throw FormatException('only ${result.length} questions');
    }
    return List.unmodifiable(result);
  }
}
