import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/parent_revoke_button.dart';

/// Bé đang làm việc hẹn giờ: máy vẫn khoá, đếm ngược tới lúc xong việc.
/// Hết giờ controller tự cộng phút và chuyển sang màn dùng máy.
class TaskTimerScreen extends StatelessWidget {
  const TaskTimerScreen({super.key});

  Future<void> _cancel(BuildContext context) async {
    final l10n = context.l10n;
    final controller = DependenciesScope.of(context).guardController;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.taskTimerCancelTitle),
        content: Text(l10n.taskTimerCancelBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.taskTimerCancelConfirm),
          ),
        ],
      ),
    );
    if (ok == true) await controller.cancelTimerTask();
  }

  @override
  Widget build(BuildContext context) {
    final controller = DependenciesScope.of(context).guardController;
    final session = controller.session!;
    final task = session.currentTask;
    final endsAt = session.taskEndsAt;
    final l10n = context.l10n;
    if (task == null || endsAt == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final total = task.duration ?? Duration.zero;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Column(
            children: [
              Text(
                task.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              ValueListenableBuilder<DateTime>(
                valueListenable: controller.clockTick,
                builder: (context, now, _) {
                  var left = endsAt.difference(now);
                  if (left.isNegative) left = Duration.zero;
                  final progress = total.inMilliseconds <= 0
                      ? 0.0
                      : (1 - left.inMilliseconds / total.inMilliseconds).clamp(
                          0.0,
                          1.0,
                        );
                  return SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 16,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.black12,
                          color: AppColors.kid,
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.taskTimerLeft,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                formatCountdown(left),
                                style: const TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w800,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                l10n.taskTimerHint(l10n.duration(task.reward)),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => _cancel(context),
                icon: const Icon(Icons.swap_horiz_rounded),
                label: Text(l10n.taskTimerCancel),
              ),
              const SizedBox(height: 8),
              const ParentRevokeButton(color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
