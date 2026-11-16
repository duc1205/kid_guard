import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:main_app/data/datasources/app_database.dart';
import 'package:main_app/data/models/json_mappers.dart';
import 'package:main_app/data/repositories/sqlite_repositories.dart';
import 'package:main_app/domain/entities/active_session.dart';
import 'package:main_app/domain/entities/child_profile.dart';
import 'package:main_app/domain/entities/study_task.dart';
import 'package:main_app/domain/usecases/pick_question.dart';
import 'package:main_app/domain/usecases/register_child.dart';
import 'package:main_app/domain/usecases/session_usecases.dart';
import 'package:main_app/domain/usecases/study_task_usecases.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../fakes.dart';

/// Việc học hằng ngày: hết giờ → chọn việc → được thêm phút.
void main() {
  late AppDatabase db;
  late FakeClock clock;
  late SqliteUsageLogRepository logs;
  late SqliteStudyTaskRepository tasks;
  late InMemoryActiveSessionRepository active;
  late FakeDevice device;
  late StartSessionUseCase start;
  late HandleTimeUpUseCase timeUp;
  late SaveStudyTaskUseCase save;
  late GetTodayTasksUseCase today;
  late ChooseQuizUseCase chooseQuiz;
  late StartTimerTaskUseCase startTimer;
  late CancelTimerTaskUseCase cancelTimer;
  late CompleteTaskUseCase complete;
  late ChildProfile child;
  var idSeq = 0;

  setUp(() async {
    db = await openTestDatabase();
    clock = FakeClock(DateTime(2026, 11, 16, 17));
    logs = SqliteUsageLogRepository(db);
    tasks = SqliteStudyTaskRepository(db);
    active = InMemoryActiveSessionRepository();
    device = FakeDevice();
    String newId() => 'id${idSeq++}';
    final children = SqliteChildRepository(db);
    final pick = PickQuestionUseCase(
      FakeQuestionRepository([q('q1'), q('q2')]),
      logs,
      random: Random(1),
      clock: clock.call,
    );
    today = GetTodayTasksUseCase(tasks, clock: clock.call);
    save = SaveStudyTaskUseCase(tasks, newId, clock: clock.call);
    start = StartSessionUseCase(
      active,
      logs,
      device,
      FakeSettings(),
      newId,
      clock: clock.call,
    );
    timeUp = HandleTimeUpUseCase(
      active,
      logs,
      device,
      pick,
      today,
      clock: clock.call,
    );
    chooseQuiz = ChooseQuizUseCase(active, pick);
    startTimer = StartTimerTaskUseCase(active, clock: clock.call);
    cancelTimer = CancelTimerTaskUseCase(active);
    complete = CompleteTaskUseCase(
      active,
      tasks,
      today,
      device,
      clock: clock.call,
    );
    child = await RegisterChildUseCase(children, newId, clock: clock.call)(
      name: 'An',
      dateOfBirth: DateTime(2018),
      grade: 3,
    );
  });

  tearDown(() => db.close());

  Future<ActiveSession> runOut() async {
    final s = await start(child);
    clock.advance(const Duration(minutes: 15));
    return timeUp(s);
  }

  test('chưa có việc học → hết giờ hỏi câu hỏi như cũ', () async {
    final s = await runOut();
    expect(s.status, GuardStatus.quiz);
    expect(s.currentQuestion, isNotNull);
    expect(device.guard, isTrue);
  });

  test('có việc học → hết giờ chọn việc; chọn câu hỏi thì hỏi', () async {
    await save(
      childId: child.id,
      title: 'Làm bài tập',
      kind: StudyTaskKind.check,
      reward: const Duration(minutes: 20),
    );
    final s = await runOut();
    expect(s.status, GuardStatus.tasks);
    expect(s.currentQuestion, isNull);
    expect(device.guard, isTrue);

    final quiz = await chooseQuiz(s);
    expect(quiz.status, GuardStatus.quiz);
    expect(quiz.currentQuestion, isNotNull);
  });

  test('việc bố mẹ duyệt: thêm phút, ghi lịch sử, mỗi ngày 1 lần', () async {
    final task = await save(
      childId: child.id,
      title: '  Làm   bài tập ',
      kind: StudyTaskKind.check,
      reward: const Duration(minutes: 20),
    );
    expect(task.title, 'Làm bài tập');
    var s = await runOut();
    s = await complete(s, task);
    expect(s.status, GuardStatus.running);
    expect(s.endsAt, clock.value.add(const Duration(minutes: 20)));
    expect(device.timerEndsAt, s.endsAt);
    expect(device.guard, isFalse);
    expect((await today(child.id)).single.done, isTrue);

    final log = (await logs.getLogsForChild(child.id, limit: 1)).single;
    expect(log.completions.single.title, 'Làm bài tập');
    expect(log.completions.single.reward, const Duration(minutes: 20));

    // Hết giờ lần nữa: việc duy nhất đã xong hôm nay → hỏi câu hỏi.
    clock.advance(const Duration(minutes: 20));
    s = await timeUp(s);
    expect(s.status, GuardStatus.quiz);

    // Sang ngày mới → việc lại hiện ra.
    clock.advance(const Duration(days: 1));
    expect((await today(child.id)).single.done, isFalse);
  });

  test(
    'việc hẹn giờ: chưa đủ giờ không được thưởng; dừng thì quay lại',
    () async {
      final task = await save(
        childId: child.id,
        title: 'Đọc sách',
        kind: StudyTaskKind.timer,
        duration: const Duration(minutes: 20),
        reward: const Duration(minutes: 15),
      );
      var s = await runOut();
      s = await startTimer(s, task);
      expect(s.status, GuardStatus.taskTimer);
      expect(s.taskEndsAt, clock.value.add(const Duration(minutes: 20)));
      expect(device.guard, isTrue);

      // Phiên lưu lại được (tắt app mở lại vẫn đếm tiếp).
      final restored = ActiveSessionMapper.fromJson(
        ActiveSessionMapper.toJson(s),
      );
      expect(restored.currentTask?.id, task.id);
      expect(restored.taskEndsAt, s.taskEndsAt);

      clock.advance(const Duration(minutes: 19));
      expect((await complete(s, task)).status, GuardStatus.taskTimer);

      final back = await cancelTimer(s);
      expect(back.status, GuardStatus.tasks);
      expect(back.currentTask, isNull);

      s = await startTimer(back, task);
      clock.advance(const Duration(minutes: 20));
      s = await complete(s, task);
      expect(s.status, GuardStatus.running);
      expect(s.endsAt, clock.value.add(const Duration(minutes: 15)));
      expect(s.currentTask, isNull);
    },
  );

  test('việc bố mẹ duyệt không hoàn thành được từ màn khác', () async {
    final task = await save(
      childId: child.id,
      title: 'Dọn bàn học',
      kind: StudyTaskKind.check,
      reward: const Duration(minutes: 10),
    );
    final running = await start(child);
    expect((await complete(running, task)).status, GuardStatus.running);
    expect((await today(child.id)).single.done, isFalse);
  });

  test('tên việc bắt buộc; sửa giữ id và thứ tự; xoá bé xoá việc', () async {
    expect(
      () => save(
        childId: child.id,
        title: '   ',
        kind: StudyTaskKind.check,
        reward: const Duration(minutes: 5),
      ),
      throwsA(isA<ValidationException>()),
    );
    final a = await save(
      childId: child.id,
      title: 'A',
      kind: StudyTaskKind.check,
      reward: const Duration(minutes: 5),
    );
    final b = await save(
      childId: child.id,
      title: 'B',
      kind: StudyTaskKind.timer,
      reward: const Duration(minutes: 5),
    );
    expect(b.duration, isNotNull);
    expect(b.position, a.position + 1);
    await save(
      existing: b,
      childId: child.id,
      title: 'B2',
      kind: StudyTaskKind.check,
      reward: const Duration(minutes: 30),
    );
    final list = await tasks.getTasks(child.id);
    expect(list.map((t) => t.title), ['A', 'B2']);
    expect(list.last.duration, isNull);

    await SqliteChildRepository(db).deleteChild(child.id);
    expect(await tasks.getTasks(child.id), isEmpty);
  });

  test('nâng cấp CSDL v2 → v3 giữ dữ liệu cũ', () async {
    sqfliteFfiInit();
    final dir = await Directory.systemTemp.createTemp('kg_db');
    final path = p.join(dir.path, 'kg.db');
    final old = await databaseFactoryFfiNoIsolate.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, _) async {
          await db.execute(
            'CREATE TABLE children (id TEXT PRIMARY KEY, name TEXT NOT NULL, '
            'dob INTEGER NOT NULL, grade INTEGER NOT NULL, created_at INTEGER NOT NULL)',
          );
          await db.execute(
            'CREATE TABLE sessions (id TEXT PRIMARY KEY, child_id TEXT NOT NULL '
            'REFERENCES children(id) ON DELETE CASCADE, child_name TEXT NOT NULL, '
            'grade INTEGER NOT NULL, started_at INTEGER NOT NULL, ended_at INTEGER, '
            'locked_at INTEGER, used_seconds INTEGER NOT NULL DEFAULT 0)',
          );
          await db.insert('children', {
            'id': 'c1',
            'name': 'An',
            'dob': 0,
            'grade': 3,
            'created_at': 0,
          });
        },
      ),
    );
    await old.close();

    final upgraded = await AppDatabase.open(
      factory: databaseFactoryFfiNoIsolate,
      path: path,
    );
    final repo = SqliteStudyTaskRepository(upgraded);
    await SaveStudyTaskUseCase(repo, () => 't1')(
      childId: 'c1',
      title: 'Đọc sách',
      kind: StudyTaskKind.check,
      reward: const Duration(minutes: 10),
    );
    expect((await repo.getTasks('c1')).single.title, 'Đọc sách');
    expect(await upgraded.db.query('children'), hasLength(1));
    await upgraded.close();
    await dir.delete(recursive: true);
  });
}
