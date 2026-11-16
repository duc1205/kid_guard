import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/study_task.dart';
import '../../../domain/repositories/repositories.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/parent_auth_flow.dart';
import '../../widgets/parent_revoke_button.dart';

/// Hết giờ: bé chọn một việc học để được dùng tiếp, hoặc trả lời câu hỏi.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late final Future<List<TodayTask>> _tasks = DependenciesScope.of(
    context,
  ).guardController.todayTasks();
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _approve(StudyTask task) => _run(() async {
    final controller = DependenciesScope.of(context).guardController;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final result = await controller.approveTask(
      task,
      reason: l10n.authReasonApproveTask(task.title),
    );
    if (result == ParentAuthResult.success) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: Text(l10n.tasksApproved(l10n.duration(task.reward))),
        ),
      );
    } else if (mounted) {
      showParentAuthMessage(context, result);
    }
  });

  @override
  Widget build(BuildContext context) {
    final controller = DependenciesScope.of(context).guardController;
    final session = controller.session!;
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<TodayTask>>(
          future: _tasks,
          builder: (context, snap) {
            final tasks = snap.data;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Row(
                  children: [
                    const Icon(Icons.alarm_rounded, color: AppColors.danger),
                    const SizedBox(width: 8),
                    Text(
                      l10n.tasksTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.tasksIntro(session.child.name),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                if (tasks == null)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  for (final t in tasks)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TaskCard(
                        item: t,
                        busy: _busy,
                        onApprove: () => _approve(t.task),
                        onStart: () =>
                            _run(() => controller.startTimerTask(t.task)),
                      ),
                    ),
                  if (tasks.isNotEmpty && tasks.every((t) => t.done))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        l10n.tasksAllDone,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  _QuizCard(
                    busy: _busy,
                    onTap: () => _run(controller.chooseQuiz),
                  ),
                ],
                const SizedBox(height: 12),
                const Center(
                  child: ParentRevokeButton(color: AppColors.textSecondary),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.item,
    required this.busy,
    required this.onApprove,
    required this.onStart,
  });

  final TodayTask item;
  final bool busy;
  final VoidCallback onApprove;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final task = item.task;
    final timer = task.kind == StudyTaskKind.timer;
    final color = timer ? AppColors.kid : AppColors.primary;
    return Opacity(
      opacity: item.done ? 0.6 : 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _IconSquare(
                    icon: timer
                        ? Icons.timer_rounded
                        : Icons.fact_check_rounded,
                    color: color,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          timer
                              ? l10n.tasksKindTimer(
                                  l10n.duration(task.duration!),
                                )
                              : l10n.tasksKindCheck,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _RewardChip(l10n.tasksReward(l10n.duration(task.reward))),
                ],
              ),
              const SizedBox(height: 14),
              if (item.done)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.tasksDoneToday,
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              else if (timer)
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.kid),
                  onPressed: busy ? null : onStart,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l10n.tasksStartTimer),
                )
              else
                FilledButton.icon(
                  onPressed: busy ? null : onApprove,
                  icon: const Icon(Icons.done_all_rounded),
                  label: Text(l10n.tasksAskParent),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({required this.busy, required this.onTap});
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const _IconSquare(
                  icon: Icons.quiz_rounded,
                  color: AppColors.success,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.tasksQuizTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        l10n.tasksQuizBody(
                          l10n.duration(AppConstants.bonusPerCorrectAnswer),
                        ),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: busy ? null : onTap,
              child: Text(l10n.tasksQuizButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconSquare extends StatelessWidget {
  const _IconSquare({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: color),
  );
}

class _RewardChip extends StatelessWidget {
  const _RewardChip(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: AppColors.success.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: AppColors.success,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}
