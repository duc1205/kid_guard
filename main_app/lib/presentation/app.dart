import 'package:flutter/material.dart';

import '../core/di/injection.dart';
import '../core/theme/app_theme.dart';
import '../domain/entities/active_session.dart';
import 'screens/child/locked_screen.dart';
import 'screens/child/quiz_screen.dart';
import 'screens/child/review_screen.dart';
import 'screens/child/running_screen.dart';
import 'screens/home_screen.dart';
import 'l10n_ext.dart';
import 'widgets/dependencies_scope.dart';

class KidGuardApp extends StatelessWidget {
  const KidGuardApp({super.key, required this.deps});

  final AppDependencies deps;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      deps: deps,
      child: MaterialApp(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        // Theo ngôn ngữ máy: tiếng Việt → vi, ngôn ngữ khác → en.
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        localeListResolutionCallback: (locales, _) => resolveAppLocale(locales),
        home: const _Root(),
      ),
    );
  }
}

/// Chọn màn hình theo trạng thái phiên. Khi có phiên đang chạy, mọi màn hình
/// khác bị đóng và nút Back bị vô hiệu.
class _Root extends StatefulWidget {
  const _Root();

  @override
  State<_Root> createState() => _RootState();
}

class _RootState extends State<_Root> with WidgetsBindingObserver {
  bool _hadSession = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final deps = DependenciesScope.of(context);
      deps.guardController.onResumed();
      deps.questionBankController.syncInBackground();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = DependenciesScope.of(context).guardController;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final session = controller.session;
        final hasSession = session != null;
        if (hasSession != _hadSession) {
          _hadSession = hasSession;
          // Phiên bắt đầu/kết thúc → đóng mọi màn hình đang mở phía trên.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
          });
        }
        if (session == null) return const HomeScreen();

        final screen = switch (session.status) {
          GuardStatus.running => const RunningScreen(),
          GuardStatus.quiz => const QuizScreen(),
          GuardStatus.review => const ReviewScreen(),
          GuardStatus.locked => const LockedScreen(),
        };
        return PopScope(
          canPop: false,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: KeyedSubtree(key: ValueKey(session.status), child: screen),
          ),
        );
      },
    );
  }
}
