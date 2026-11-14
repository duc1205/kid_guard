import 'package:main_app/data/datasources/app_database.dart';
import 'package:main_app/domain/entities/active_session.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:main_app/domain/entities/child_profile.dart';
import 'package:main_app/domain/entities/question.dart';
import 'package:main_app/domain/repositories/repositories.dart';

class FakeClock {
  FakeClock(this.value);
  DateTime value;
  DateTime call() => value;
  void advance(Duration d) => value = value.add(d);
}

class InMemoryChildRepository implements ChildRepository {
  final children = <ChildProfile>[];
  @override
  Future<List<ChildProfile>> getChildren() async => List.of(children);
  @override
  Future<void> saveChild(ChildProfile child) async {
    children.removeWhere((c) => c.id == child.id);
    children.add(child);
  }
}

class InMemoryActiveSessionRepository implements ActiveSessionRepository {
  ActiveSession? active;
  @override
  Future<void> clear() async => active = null;
  @override
  Future<ActiveSession?> get() async => active;
  @override
  Future<void> save(ActiveSession session) async => active = session;
}

class FakeQuestionRepository implements QuestionRepository {
  FakeQuestionRepository(this.questions);
  final List<Question> questions;
  @override
  Future<List<Question>> getQuestionsForGrade(int grade) async =>
      questions.where((q) => q.grade == grade).toList();
}

class FakeDevice implements DeviceControlRepository {
  DateTime? timerEndsAt;
  bool guard = false;
  bool stopped = false;
  @override
  Future<DevicePermissions> getPermissions() async => const DevicePermissions(
    overlay: true,
    notifications: true,
    deviceOwner: false,
    supported: true,
  );
  @override
  Future<void> moveToBackground() async {}
  @override
  Future<void> requestNotificationPermission() async {}
  @override
  Future<void> requestOverlayPermission() async {}
  @override
  Future<void> setGuard(bool enabled) async => guard = enabled;
  @override
  Future<void> startTimer(DateTime endsAt) async {
    timerEndsAt = endsAt;
    stopped = false;
  }

  @override
  Future<void> stop() async => stopped = true;
  @override
  Future<void> suspendGuard(bool suspended) async {}
  @override
  Future<void> requestIgnoreBatteryOptimizations() async {}
  @override
  Future<bool> openAutoStartSettings() async => true;
  @override
  Future<bool> openBackgroundPopupSettings() async => true;
  @override
  Future<void> openAppSettings() async {}
  @override
  Future<bool> clearDeviceOwner() async => true;
  @override
  Future<bool> requestScreenTimeAuthorization() async => true;
  @override
  Future<bool> chooseLimitedApps() async => true;
}

Question q(String id, {int grade = 3, int answer = 0}) => Question(
  id: id,
  grade: grade,
  subject: 'Toán',
  topic: 'Phép cộng',
  type: QuestionType.academic,
  text: 'Câu $id',
  options: const ['a', 'b', 'c', 'd'],
  answerIndex: answer,
  suggestion: 'Ôn lại phép cộng',
);

/// CSDL SQLite thật, chạy trong bộ nhớ (không cần thiết bị).
Future<AppDatabase> openTestDatabase() {
  sqfliteFfiInit();
  return AppDatabase.open(
    factory: databaseFactoryFfiNoIsolate,
    path: inMemoryDatabasePath,
  );
}
