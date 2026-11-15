import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:main_app/domain/entities/question.dart';
import 'package:main_app/domain/entities/usage_stats.dart';
import 'package:main_app/domain/repositories/repositories.dart';
import 'package:main_app/domain/usecases/pick_question.dart';

import '../fakes.dart';

/// Chỉ cần 2 hàm cho việc chọn câu; phần còn lại không dùng tới.
class _Logs implements UsageLogRepository {
  _Logs({this.recent = const [], this.weak = const []});
  final List<String> recent;
  final List<WeakTopic> weak;

  @override
  Future<List<String>> recentQuestionIds(
    String childId, {
    required int limit,
  }) async => recent;

  @override
  Future<List<WeakTopic>> getWeakTopics(
    String childId, {
    required int limit,
  }) async => weak;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// nextDouble cố định để chọn nhánh "ôn chủ đề yếu" hay không.
class _Random implements Random {
  _Random(this.fixed, [int seed = 1]) : _inner = Random(seed);
  final double fixed;
  final Random _inner;
  @override
  double nextDouble() => fixed;
  @override
  int nextInt(int max) => _inner.nextInt(max);
  @override
  bool nextBool() => _inner.nextBool();
}

Question tq(String id, {int? term, String topic = 'Phép cộng'}) {
  final base = q(id);
  return Question(
    id: id,
    grade: base.grade,
    subject: base.subject,
    topic: topic,
    type: base.type,
    text: base.text,
    options: base.options,
    answerIndex: base.answerIndex,
    suggestion: base.suggestion,
    term: term,
  );
}

void main() {
  Future<Set<String>> pickMany(
    PickQuestionUseCase pick, {
    int times = 60,
  }) async => {
    for (var i = 0; i < times; i++) (await pick(childId: 'c', grade: 3)).id,
  };

  final bank = [tq('hk1', term: 1), tq('hk2', term: 2), tq('canam')];

  test('học kỳ 1: chưa hỏi câu của học kỳ 2', () async {
    final pick = PickQuestionUseCase(
      FakeQuestionRepository(bank),
      _Logs(),
      random: Random(3),
      clock: () => DateTime(2026, 10, 1),
    );
    expect(await pickMany(pick), {'hk1', 'canam'});
  });

  test('học kỳ 2 và nghỉ hè: hỏi được mọi câu', () async {
    for (final month in [3, 7]) {
      final pick = PickQuestionUseCase(
        FakeQuestionRepository(bank),
        _Logs(),
        random: Random(3),
        clock: () => DateTime(2026, month, 1),
      );
      expect(await pickMany(pick), {'hk1', 'hk2', 'canam'}, reason: '$month');
    }
  });

  test('chỉ còn câu học kỳ sau → vẫn hỏi (không bao giờ thiếu câu)', () async {
    final pick = PickQuestionUseCase(
      FakeQuestionRepository([tq('hk2', term: 2)]),
      _Logs(),
      clock: () => DateTime(2026, 10, 1),
    );
    expect((await pick(childId: 'c', grade: 3)).id, 'hk2');
  });

  test('ưu tiên chủ đề hay sai khi rơi vào lượt ôn tập', () async {
    final topics = [
      tq('a', topic: 'Phép cộng'),
      tq('b', topic: 'Phép nhân'),
      tq('c', topic: 'Hình học'),
    ];
    const weak = [
      WeakTopic(subject: 'Toán', topic: 'Phép nhân', wrongCount: 3),
    ];
    final review = PickQuestionUseCase(
      FakeQuestionRepository(topics),
      _Logs(weak: weak),
      random: _Random(0.0),
    );
    expect(await pickMany(review, times: 20), {'b'});

    final normal = PickQuestionUseCase(
      FakeQuestionRepository(topics),
      _Logs(weak: weak),
      random: _Random(0.99),
    );
    expect(await pickMany(normal), {'a', 'b', 'c'});
  });

  test(
    'tránh câu vừa hỏi; chủ đề yếu chỉ có câu vừa hỏi → chọn câu khác',
    () async {
      final pick = PickQuestionUseCase(
        FakeQuestionRepository([tq('a', topic: 'Phép nhân'), tq('b')]),
        _Logs(
          recent: ['a'],
          weak: const [
            WeakTopic(subject: 'Toán', topic: 'Phép nhân', wrongCount: 2),
          ],
        ),
        random: _Random(0.0),
      );
      expect(await pickMany(pick, times: 10), {'b'});
    },
  );
}
