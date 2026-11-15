// Chụp màn hình các màn chính để rà giao diện (không chạy trong CI).
// fvm flutter test test/screenshots --update-goldens --dart-define=SHOTS=/abs/dir
// ignore_for_file: invalid_use_of_protected_member
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:main_app/core/di/injection.dart';
import 'package:main_app/domain/entities/active_session.dart';
import 'package:main_app/domain/repositories/repositories.dart';
import 'package:main_app/presentation/app.dart';
import 'package:main_app/presentation/screens/parent/advanced_lock_screen.dart';
import 'package:main_app/presentation/screens/parent/child_report_screen.dart';
import 'package:main_app/presentation/screens/parent/parent_dashboard_screen.dart';
import 'package:main_app/presentation/screens/parent/question_source_screen.dart';
import 'package:main_app/presentation/screens/child/child_register_screen.dart';
import 'package:main_app/presentation/screens/setup/privacy_policy_screen.dart';

import '../fakes.dart';

const _out = String.fromEnvironment('SHOTS');

class _AndroidDevice extends FakeDevice {
  @override
  Future<DevicePermissions> getPermissions() async => const DevicePermissions(
    platform: DevicePlatform.android,
    overlay: true,
    notifications: true,
    deviceOwner: false,
    accessibility: false,
    androidSdk: 33,
    supported: true,
    batteryUnrestricted: false,
    manufacturer: 'OPPO',
  );
}

class _Auth implements ParentAuthRepository {
  @override
  Future<bool> isAvailable() async => true;
  @override
  Future<ParentAuthResult> authenticate(String reason) async =>
      ParentAuthResult.success;
}

Future<void> _loadFonts() async {
  final root = Platform.environment['FLUTTER_ROOT']!;
  final dir = '$root/bin/cache/artifacts/material_fonts';
  Future<ByteData> f(String p) async =>
      ByteData.sublistView(await File(p).readAsBytes());
  final roboto = FontLoader('Roboto');
  for (final w in ['Regular', 'Medium', 'Bold', 'Black', 'Light']) {
    roboto.addFont(f('$dir/Roboto-$w.ttf'));
  }
  await roboto.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(f('$dir/MaterialIcons-Regular.otf'));
  await icons.load();
  // Font riêng của app (nếu có) trong assets/fonts.
  final fontDir = Directory('assets/fonts');
  if (!fontDir.existsSync()) return;
  for (final fam in const ['Nunito', 'BeVietnamPro']) {
    final files = fontDir
        .listSync()
        .whereType<File>()
        .where((e) => e.path.contains(fam))
        .toList();
    if (files.isEmpty) continue;
    final l = FontLoader(fam);
    for (final file in files) {
      l.addFont(f(file.path));
    }
    await l.load();
  }
}

Future<AppDependencies> _deps({
  bool consent = true,
  bool lockDropped = false,
}) async {
  final store = MemoryLocalStore();
  if (consent) await store.writeBool('kg.parent_consent_v1', true);
  if (lockDropped) await store.writeBool('kg.advanced_lock_seen_on', true);
  return AppDependencies.create(
    store: store,
    database: await openTestDatabase(),
    device: _AndroidDevice(),
    parentAuth: _Auth(),
    remote: fakeRemote((_) async => (404, const <int>[])),
  );
}

void main() {
  late AppDependencies deps;

  setUpAll(() async {
    await initializeDateFormatting();
    await _loadFonts();
  });

  Future<void> boot(
    WidgetTester t, {
    bool consent = true,
    bool lockDropped = false,
  }) async {
    t.view.physicalSize = const Size(1080, 2340);
    t.view.devicePixelRatio = 2.625;
    t.platformDispatcher.localesTestValue = const [Locale('vi')];
    addTearDown(t.view.reset);
    addTearDown(t.platformDispatcher.clearLocalesTestValue);
    await t.runAsync(() async {
      deps = await _deps(consent: consent, lockDropped: lockDropped);
    });
    await t.pumpWidget(KidGuardApp(deps: deps));
    await t.runAsync(() => deps.guardController.init());
    await settle(t);
  }

  Future<void> shot(WidgetTester t, String name) async {
    await settle(t);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(Uri.file('$_out/$name.png')),
    );
  }

  Future<void> push(WidgetTester t, Widget screen) async {
    t
        .state<NavigatorState>(find.byType(Navigator).first)
        .push(MaterialPageRoute<void>(builder: (_) => screen));
    await settle(t);
  }

  Future<void> startChild() async {
    await deps.guardController.startForChild(
      name: 'Minh Anh',
      dateOfBirth: DateTime(2017, 5, 2),
      grade: 3,
    );
  }

  Future<void> timeUp(WidgetTester t) async {
    final g = deps.guardController;
    g.session = g.session!.copyWith(
      endsAt: DateTime.now().subtract(const Duration(seconds: 1)),
    );
    await t.runAsync(g.onResumed);
    await settle(t);
  }

  tearDown(() async {
    deps.guardController.dispose();
  });

  shotTest('01 consent', (t) async {
    await boot(t, consent: false);
    await shot(t, '01_consent');
  });

  shotTest('02 home', (t) async {
    await boot(t);
    await shot(t, '02_home');
    await t.drag(find.byType(ListView).first, const Offset(0, -900));
    await shot(t, '03_home_scrolled');
  });

  shotTest('04 register', (t) async {
    await boot(t);
    await push(t, const ChildRegisterScreen());
    await t.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await shot(t, '04_register_form');
  });

  shotTest('05 child flow', (t) async {
    await boot(t);
    await t.runAsync(startChild);
    await settle(t);
    await shot(t, '05_running');
    await timeUp(t);
    await shot(t, '06_quiz');
    final q = deps.guardController.session!.currentQuestion!;
    final wrong = [0, 1, 2, 3].firstWhere((i) => !q.isCorrect(i));
    await t.runAsync(() => deps.guardController.answer(wrong));
    await settle(t);
    await shot(t, '07_review');
    final g = deps.guardController;
    g.session = g.session!.copyWith(status: GuardStatus.locked);
    g.notifyListeners();
    await shot(t, '08_locked');
  });

  shotTest('09 parent', (t) async {
    await boot(t);
    await t.runAsync(() async {
      await startChild();
      deps.guardController.session = deps.guardController.session!.copyWith(
        endsAt: DateTime.now().subtract(const Duration(seconds: 1)),
      );
      await deps.guardController.onResumed();
      final q = deps.guardController.session!.currentQuestion!;
      await deps.guardController.answer(
        [0, 1, 2, 3].firstWhere((i) => q.isCorrect(i)),
      );
      await deps.guardController.parentRevoke(reason: 'x');
      await deps.parentController.load();
    });
    await settle(t);
    await push(t, const ParentDashboardScreen());
    await t.runAsync(() => deps.parentController.load());
    await shot(t, '09_dashboard');
    await push(
      t,
      ChildReportScreen(report: deps.parentController.reports.first),
    );
    await shot(t, '10_report');
  });

  shotTest('14 advanced lock dropped', (t) async {
    await boot(t, lockDropped: true);
    await shot(t, '14_home_lock_dropped');
    await t.tap(find.byType(FilledButton).at(1));
    await settle(t);
    await shot(t, '15_start_dialog');
    await t.tap(find.byType(FilledButton).last);
    await settle(t);
    await shot(t, '16_advanced_lock_dropped');
  });

  shotTest('11 settings screens', (t) async {
    await boot(t);
    await push(t, const AdvancedLockScreen());
    await shot(t, '11_advanced_lock');
    await push(t, const QuestionSourceScreen());
    await shot(t, '12_question_source');
    await push(t, const PrivacyPolicyScreen());
    await shot(t, '13_privacy');
  });
}

Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 20; i++) {
    await t.pump(const Duration(milliseconds: 100));
    await t.runAsync(() => Future<void>.delayed(Duration.zero));
  }
}

void shotTest(String name, Future<void> Function(WidgetTester) body) =>
    testWidgets(
      name,
      body,
      skip: _out.isEmpty,
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );
