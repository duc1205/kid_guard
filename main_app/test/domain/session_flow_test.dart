import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:main_app/core/constants/app_constants.dart';
import 'package:main_app/data/datasources/app_database.dart';
import 'package:main_app/data/repositories/sqlite_repositories.dart';
import 'package:main_app/domain/entities/active_session.dart';
import 'package:main_app/domain/usecases/parent_usecases.dart';
import 'package:main_app/domain/usecases/pick_question.dart';
import 'package:main_app/domain/usecases/register_child.dart';
import 'package:main_app/domain/usecases/session_usecases.dart';

import '../fakes.dart';

/// Kiểm thử toàn bộ luồng nghiệp vụ với SQLite thật (in-memory).
void main() {
  late AppDatabase db;
  late FakeClock clock;
  late SqliteChildRepository children;
  late SqliteUsageLogRepository logs;
  late InMemoryActiveSessionRepository active;
  late FakeDevice device;
  late RegisterChildUseCase register;
  late StartSessionUseCase start;
  late HandleTimeUpUseCase timeUp;
  late SubmitAnswerUseCase submit;
  late AcknowledgeWrongAnswerUseCase ack;
  late RevokeSessionUseCase revoke;
  late GetChildReportsUseCase reports;
  var idSeq = 0;

  setUp(() async {
    db = await openTestDatabase();
    clock = FakeClock(DateTime(2026, 11, 14, 9));
    children = SqliteChildRepository(db);
    logs = SqliteUsageLogRepository(db);
    active = InMemoryActiveSessionRepository();
    device = FakeDevice();
    String newId() => 'id${idSeq++}';
    final pick = PickQuestionUseCase(
      FakeQuestionRepository([q('q1'), q('q2'), q('q3')]),
      logs,
      random: Random(1),
    );
    register = RegisterChildUseCase(children, newId, clock: clock.call);
    start = StartSessionUseCase(active, logs, device, newId, clock: clock.call);
    timeUp = HandleTimeUpUseCase(active, logs, device, pick, clock: clock.call);
    submit = SubmitAnswerUseCase(active, logs, device, clock: clock.call);
    ack = AcknowledgeWrongAnswerUseCase(
      active,
      logs,
      device,
      clock: clock.call,
    );
    revoke = RevokeSessionUseCase(active, logs, device, clock: clock.call);
    reports = GetChildReportsUseCase(children, logs);
  });

  tearDown(() => db.close());

  test(
    'đăng ký bắt buộc đủ tên, ngày sinh, lớp 1–12 / Đại học / Sau đại học',
    () async {
      expect(
        () => register(name: ' ', dateOfBirth: DateTime(2018), grade: 3),
        throwsA(isA<ValidationException>()),
      );
      expect(
        () => register(name: 'An', dateOfBirth: null, grade: 3),
        throwsA(isA<ValidationException>()),
      );
      expect(
        () => register(name: 'An', dateOfBirth: DateTime(2018), grade: 15),
        throwsA(isA<ValidationException>()),
      );
      final c = await register(
        name: '  Minh   An ',
        dateOfBirth: DateTime(2018, 5, 2),
        grade: 3,
      );
      expect(c.name, 'Minh An');
      await start(c);
      // Cùng tên + ngày sinh → dùng lại hồ sơ, cập nhật lớp, KHÔNG mất lịch sử cũ.
      final again = await register(
        name: 'minh an',
        dateOfBirth: DateTime(2018, 5, 2),
        grade: 4,
      );
      expect(again.id, c.id);
      final all = await children.getChildren();
      expect(all.single.grade, 4);
      expect(await logs.getLogsForChild(c.id, limit: 10), hasLength(1));
    },
  );

  test('chấp nhận bậc Đại học và Sau đại học', () async {
    for (final g in [
      AppConstants.universityGrade,
      AppConstants.postgraduateGrade,
    ]) {
      final c = await register(
        name: 'Người học $g',
        dateOfBirth: DateTime(1998, 3, 4),
        grade: g,
      );
      expect(c.grade, g);
    }
  });

  test(
    '15 phút → câu hỏi → đúng +5 phút → sai → gợi ý → khoá → người lớn thu hồi',
    () async {
      final child = await register(
        name: 'An',
        dateOfBirth: DateTime(2018, 1, 1),
        grade: 3,
      );
      var s = await start(child);
      expect(s.status, GuardStatus.running);
      expect(s.endsAt, clock.value.add(const Duration(minutes: 15)));
      expect(device.timerEndsAt, s.endsAt);

      clock.advance(const Duration(minutes: 14));
      expect((await timeUp(s)).status, GuardStatus.running);

      clock.advance(const Duration(minutes: 1));
      s = await timeUp(s);
      expect(s.status, GuardStatus.quiz);
      expect(s.currentQuestion, isNotNull);
      expect(device.guard, isTrue);

      clock.advance(const Duration(seconds: 20));
      s = await submit(s, s.currentQuestion!.answerIndex);
      expect(s.status, GuardStatus.running);
      expect(s.endsAt, clock.value.add(const Duration(minutes: 5)));
      expect(device.guard, isFalse);

      clock.advance(const Duration(minutes: 5));
      s = await timeUp(s);
      final shown = s.currentQuestion!;
      final wrong = (shown.answerIndex + 1) % 4;
      s = await submit(s, wrong);
      expect(s.status, GuardStatus.review);

      s = await ack(s);
      expect(s.status, GuardStatus.locked);
      expect(device.guard, isTrue);

      await revoke(s);
      expect(active.active, isNull);
      expect(device.stopped, isTrue);

      final log = (await logs.getLogsForChild(child.id, limit: 10)).single;
      expect(log.usedTime, const Duration(minutes: 20));
      expect(log.correctCount, 1);
      expect(log.wrongCount, 1);
      expect(log.lockedAt, isNotNull);
      expect(log.endedAt, isNotNull);
      // Đọc lại từ CSDL vẫn đúng thứ tự đáp án trẻ đã thấy.
      final wrongAttempt = log.attempts.last;
      expect(wrongAttempt.options, shown.options);
      expect(wrongAttempt.chosenIndex, wrong);
      expect(
        wrongAttempt.options[wrongAttempt.correctIndex],
        shown.options[shown.answerIndex],
      );

      final r = (await reports()).single;
      expect(r.stats.totalUsed, const Duration(minutes: 20));
      expect(r.stats.correct, 1);
      expect(r.stats.wrong, 1);
      expect(
        (await logs.getWeakTopics(child.id, limit: 5)).single.wrongCount,
        1,
      );
    },
  );

  test('thu hồi giữa chừng chỉ tính thời gian thực sự đã dùng', () async {
    final child = await register(
      name: 'Bình',
      dateOfBirth: DateTime(2015, 1, 1),
      grade: 3,
    );
    final s = await start(child);
    clock.advance(const Duration(minutes: 7));
    await revoke(s);
    final log = (await logs.getLogsForChild(child.id, limit: 1)).single;
    expect(log.usedTime, const Duration(minutes: 7));
  });

  test('không lặp lại câu vừa hỏi khi còn câu khác', () async {
    final child = await register(
      name: 'Chi',
      dateOfBirth: DateTime(2018, 1, 1),
      grade: 3,
    );
    var s = await start(child);
    final seen = <String>{};
    for (var i = 0; i < 3; i++) {
      clock.advance(const Duration(minutes: 15));
      s = await timeUp(s);
      seen.add(s.currentQuestion!.id);
      s = await submit(s, s.currentQuestion!.answerIndex);
    }
    expect(seen, {'q1', 'q2', 'q3'});
  });

  test('nội dung câu hỏi chỉ lưu 1 lần dù hỏi nhiều lần', () async {
    final child = await register(
      name: 'Dũng',
      dateOfBirth: DateTime(2018, 1, 1),
      grade: 3,
    );
    var s = await start(child);
    for (var i = 0; i < 9; i++) {
      clock.advance(const Duration(minutes: 15));
      s = await timeUp(s);
      s = await submit(s, s.currentQuestion!.answerIndex);
    }
    final snapshots = await db.db.rawQuery(
      'SELECT COUNT(*) c FROM question_snapshots',
    );
    final attempts = await db.db.rawQuery('SELECT COUNT(*) c FROM attempts');
    expect(snapshots.single['c'], 3);
    expect(attempts.single['c'], 9);
  });

  test('tự xoá nhật ký cũ hơn 180 ngày, giữ phiên đang chạy', () async {
    final child = await register(
      name: 'Em',
      dateOfBirth: DateTime(2018, 1, 1),
      grade: 3,
    );
    var s = await start(child);
    clock.advance(const Duration(minutes: 15));
    s = await timeUp(s);
    s = await submit(s, s.currentQuestion!.answerIndex);
    await revoke(s);

    clock.advance(const Duration(days: 200));
    final current = await start(child); // phiên mới, chưa kết thúc

    final deleted = await PruneOldLogsUseCase(logs, clock: clock.call)();
    expect(deleted, 1);
    final remaining = await logs.getLogsForChild(child.id, limit: 10);
    expect(remaining.single.id, current.logId);
    final snapshots = await db.db.rawQuery(
      'SELECT COUNT(*) c FROM question_snapshots',
    );
    expect(snapshots.single['c'], 0);
  });

  test('đảo đáp án vẫn giữ đúng đáp án và thứ tự gốc', () {
    final original = q('x', answer: 2);
    for (var seed = 0; seed < 20; seed++) {
      final s = original.shuffled(Random(seed));
      expect(s.options[s.answerIndex], original.options[2]);
      for (var i = 0; i < 4; i++) {
        expect(s.options[i], original.options[s.optionOrder[i]]);
      }
    }
  });
}
