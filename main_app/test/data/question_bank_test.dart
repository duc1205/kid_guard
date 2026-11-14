import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main_app/core/constants/app_constants.dart';
import 'package:main_app/data/models/json_mappers.dart';
import 'package:main_app/domain/entities/question.dart';

/// Kiểm tra ngân hàng câu hỏi đóng gói: đủ lớp 1–12, Đại học, Sau đại học, đúng định dạng, có đủ 3 loại câu.
void main() {
  for (
    var grade = AppConstants.minGrade;
    grade <= AppConstants.maxGrade;
    grade++
  ) {
    test('ngân hàng câu hỏi lớp $grade hợp lệ', () {
      final file = File('assets/questions/grade_$grade.json');
      expect(file.existsSync(), isTrue);
      final raw = jsonDecode(file.readAsStringSync()) as List;
      for (final e in raw) {
        final m = e as Map;
        expect(
          (m['source'] as String?)?.trim() ?? '',
          isNotEmpty,
          reason: '${m['id']}: thiếu nguồn chương trình (source)',
        );
      }
      final list = raw
          .map(
            (e) => QuestionMapper.fromAsset(
              Map<String, dynamic>.from(e as Map),
              grade,
            ),
          )
          .toList();
      expect(list.length, greaterThanOrEqualTo(15));
      expect(
        list.map((q) => q.id).toSet().length,
        list.length,
        reason: 'id phải duy nhất',
      );
      for (final q in list) {
        expect(q.options.length, 4, reason: q.id);
        expect(q.options.toSet().length, 4, reason: '${q.id}: đáp án trùng');
        expect(q.answerIndex, inInclusiveRange(0, 3), reason: q.id);
        expect(q.suggestion.trim(), isNotEmpty, reason: q.id);
        expect(q.text.trim(), isNotEmpty, reason: q.id);
      }
      final types = list.map((q) => q.type).toSet();
      expect(types, containsAll(QuestionType.values));
      expect(
        list.map((q) => q.subject).toSet().length,
        greaterThanOrEqualTo(4),
      );
    });
  }

  test(
    'manifest.json khớp với các file câu hỏi (chạy tool/make_question_manifest.dart)',
    () {
      final m =
          jsonDecode(File('assets/questions/manifest.json').readAsStringSync())
              as Map<String, dynamic>;
      final grades = m['grades'] as Map<String, dynamic>;
      for (
        var grade = AppConstants.minGrade;
        grade <= AppConstants.maxGrade;
        grade++
      ) {
        final entry = grades['$grade'] as Map<String, dynamic>?;
        expect(entry, isNotNull, reason: 'manifest thiếu lớp $grade');
        final bytes = File(
          'assets/questions/${entry!['file']}',
        ).readAsBytesSync();
        expect(
          sha256.convert(bytes).toString(),
          entry['sha256'],
          reason: 'grade_$grade.json đã sửa nhưng chưa sinh lại manifest',
        );
      }
    },
  );
}
