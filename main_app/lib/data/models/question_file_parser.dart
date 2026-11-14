import 'dart:convert';

import '../../domain/entities/question.dart';
import 'json_mappers.dart';

/// Đọc + kiểm tra một file grade_N.json. Dùng cho cả bộ đóng gói sẵn và bộ tải
/// từ internet: file sai định dạng bị từ chối toàn bộ (ném [FormatException])
/// để không bao giờ hiện câu hỏi hỏng — trả lời "sai" là khoá máy.
class QuestionFileParser {
  const QuestionFileParser._();

  /// Đủ để không lặp câu liên tục.
  static const minQuestions = 5;

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
      result.add(q);
    }
    if (result.length < minQuestions) {
      throw FormatException('only ${result.length} questions');
    }
    return List.unmodifiable(result);
  }
}
