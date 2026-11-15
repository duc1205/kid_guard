import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:main_app/data/models/json_mappers.dart';
import 'package:main_app/data/models/question_file_parser.dart';

/// Định dạng câu hỏi mở rộng (difficulty, term, status) — vẫn đọc được file cũ.
void main() {
  Map<String, Object?> q(int i, [Map<String, Object?> extra = const {}]) => {
    'id': 'g3_toan_$i',
    'subject': 'Toán',
    'topic': 'Chủ đề $i',
    'type': 'academic',
    'question': 'Câu $i?',
    'options': ['1', '2', '3', '4'],
    'answerIndex': 0,
    'suggestion': 'Ôn lại.',
    'source': 'CT GDPT 2018',
    ...extra,
  };
  String file(List<Map<String, Object?>> qs) => jsonEncode(qs);
  List<Map<String, Object?>> five([
    List<Map<String, Object?>> more = const [],
  ]) => [for (var i = 1; i <= 5; i++) q(i), ...more];

  test('file cũ (không có trường mới) vẫn hợp lệ', () {
    final list = QuestionFileParser.parse(file(five()), 3);
    expect(list, hasLength(5));
    expect(list.first.difficulty, isNull);
    expect(list.first.term, isNull);
  });

  test('đọc difficulty / term và giữ qua shuffle + lưu phiên', () {
    final list = QuestionFileParser.parse(
      file(
        five([
          q(6, {'difficulty': 3, 'term': 2, 'status': 'teacher-reviewed'}),
        ]),
      ),
      3,
    );
    final last = list.last;
    expect((last.difficulty, last.term), (3, 2));
    final restored = QuestionMapper.fromJson(QuestionMapper.toJson(last));
    expect((restored.difficulty, restored.term), (3, 2));
  });

  test('câu nháp bị bỏ qua nhưng vẫn tính trùng id', () {
    final list = QuestionFileParser.parse(
      file(
        five([
          q(6, {'status': 'draft'}),
        ]),
      ),
      3,
    );
    expect(list.map((e) => e.id), isNot(contains('g3_toan_6')));
    expect(
      () => QuestionFileParser.parse(
        file(
          five([
            q(1, {'status': 'draft'}),
          ]),
        ),
        3,
      ),
      throwsFormatException,
    );
  });

  test('giá trị trường mới sai → từ chối cả file', () {
    for (final bad in [
      {'difficulty': 0},
      {'difficulty': 4},
      {'difficulty': '2'},
      {'term': 3},
      {'status': 'reviewed'},
    ]) {
      expect(
        () => QuestionFileParser.parse(file(five([q(6, bad)])), 3),
        throwsFormatException,
        reason: '$bad',
      );
    }
  });

  test('chỉ còn câu nháp → không đủ câu dùng', () {
    expect(
      () => QuestionFileParser.parse(
        file([
          for (var i = 1; i <= 5; i++) q(i, {'status': 'draft'}),
        ]),
        3,
      ),
      throwsFormatException,
    );
  });

  // Luật chất lượng nằm ở repo câu hỏi (dùng chung với GitHub Action).
  final checker = File('../../kid_guard_question/scripts/check_questions.py');
  test(
    'bộ câu hỏi đóng gói qua được kiểm tra chất lượng (check_questions.py)',
    () async {
      final r = await Process.run('python3', [
        checker.path,
        'assets/questions',
        '--quiet',
      ]);
      expect(r.exitCode, 0, reason: '${r.stdout}\n${r.stderr}');
    },
    skip: checker.existsSync()
        ? false
        : 'không thấy kid_guard_question/ cạnh kid_guard/',
  );
}
