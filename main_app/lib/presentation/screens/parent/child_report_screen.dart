import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/child_profile.dart';
import '../../../domain/entities/usage_log.dart';
import '../../../domain/entities/usage_stats.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../domain/usecases/parent_usecases.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/parent_auth_flow.dart';
import '../../widgets/stat_tile.dart';
import 'edit_child_screen.dart';
import 'study_tasks_screen.dart';
import '../../widgets/parent_gate.dart';

/// Log chi tiết của một bé: từng phiên, thời gian dùng, từng câu hỏi đúng/sai.
/// Lịch sử được tải theo trang (cuộn tới cuối thì tải thêm) để mở nhanh dù dữ liệu nhiều.
class ChildReportScreen extends StatefulWidget {
  const ChildReportScreen({super.key, required this.report});

  final ChildReport report;

  @override
  State<ChildReportScreen> createState() => _ChildReportScreenState();
}

class _ChildReportScreenState extends State<ChildReportScreen> {
  final _logs = <UsageLog>[];
  List<WeakTopic> _weak = const [];
  bool _loading = false;
  bool _hasMore = true;
  int? _taskCount;

  /// Thông tin bé hiện tại (cập nhật sau khi người lớn sửa).
  late ChildProfile _child = widget.report.child;

  Future<void> _edit() async {
    final updated = await Navigator.of(context).push<ChildProfile>(
      MaterialPageRoute(builder: (_) => EditChildScreen(child: _child)),
    );
    if (updated != null && mounted) setState(() => _child = updated);
  }

  Future<void> _loadTaskCount() async {
    final tasks = await DependenciesScope.of(context).getStudyTasks(_child.id);
    if (mounted) setState(() => _taskCount = tasks.length);
  }

  Future<void> _openTasks() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => StudyTasksScreen(child: _child)));
    await _loadTaskCount();
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.childDeleteTitle(_child.name)),
        content: Text(l10n.childDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.childDeleteConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final parent = DependenciesScope.of(context).parentController;
    final auth = await askParent(context, reason: l10n.authReasonDeleteChild);
    if (!mounted) return;
    if (auth != ParentAuthResult.success) {
      showParentAuthMessage(context, auth);
      return;
    }
    final name = _child.name;
    try {
      await parent.deleteChild(_child.id);
    } on ActiveSessionExistsException {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.deleteBlockedActiveSession)));
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.childDeleted(name))));
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    final deps = DependenciesScope.of(context);
    deps.getWeakTopics(widget.report.child.id).then((w) {
      if (mounted) setState(() => _weak = w);
    });
    _loadMore();
    _loadTaskCount();
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);
    final page = await DependenciesScope.of(
      context,
    ).getChildHistory(widget.report.child.id, offset: _logs.length);
    if (!mounted) return;
    setState(() {
      _logs.addAll(page);
      _hasMore = page.length == AppConstants.historyPageSize;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = _child;
    final stats = widget.report.stats;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(c.name),
        actions: [
          IconButton(
            tooltip: l10n.childEditTooltip,
            icon: const Icon(Icons.edit_rounded),
            onPressed: _edit,
          ),
          IconButton(
            tooltip: l10n.childDeleteTooltip,
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _delete,
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.extentAfter < 400) _loadMore();
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              sliver: SliverList.list(
                children: [
                  Text(
                    l10n.reportChildInfo(
                      l10n.gradeLabel(c.grade),
                      formatDate(c.dateOfBirth),
                    ),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.checklist_rounded,
                        color: AppColors.primary,
                      ),
                      title: Text(l10n.studyTasksTitle),
                      subtitle: _taskCount == null
                          ? null
                          : Text(l10n.reportStudyTasksCount(_taskCount!)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _openTasks,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          label: l10n.reportTimeUsed,
                          value: l10n.duration(stats.totalUsed),
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatTile(
                          label: l10n.reportCorrect,
                          value: '${stats.correct}',
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatTile(
                          label: l10n.reportWrong,
                          value: '${stats.wrong}',
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                  if (_weak.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      l10n.reportWeakTopicsTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Column(
                        children: [
                          for (final w in _weak)
                            ListTile(
                              dense: true,
                              leading: const Icon(
                                Icons.flag_rounded,
                                color: AppColors.danger,
                              ),
                              title: Text('${w.subject} — ${w.topic}'),
                              trailing: Text(
                                l10n.reportWrongTimes(w.wrongCount),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    l10n.reportHistoryTitle(stats.sessionCount),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!_loading && _logs.isEmpty) Text(l10n.reportNoSessions),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.builder(
                itemCount: _logs.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SessionCard(log: _logs[i]),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                child: Center(
                  child: _loading
                      ? const CircularProgressIndicator()
                      : _hasMore
                      ? TextButton(
                          onPressed: _loadMore,
                          child: Text(l10n.reportLoadMore),
                        )
                      : Text(
                          l10n.reportLogRetention(
                            AppConstants.logRetention.inDays,
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.log});
  final UsageLog log;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = log.isActive
        ? (l10n.reportStatusActive, AppColors.primary)
        : log.lockedAt != null
        ? (l10n.reportStatusLocked, AppColors.danger)
        : (l10n.reportStatusRevoked, AppColors.success);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        title: Text(
          formatDateTime(log.startedAt),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              l10n.reportSessionSummary(
                l10n.duration(log.usedTime),
                log.attempts.length,
                log.correctCount,
                log.wrongCount,
              ),
            ),
            if (log.completions.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(l10n.reportSessionTasks(log.completions.length)),
            ],
            const SizedBox(height: 2),
            Text(
              status.$1,
              style: TextStyle(color: status.$2, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          if (log.endedAt != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.reportEndedAt(formatDateTime(log.endedAt!)),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          for (final c in log.completions)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.task_alt_rounded,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${formatTime(c.completedAt).substring(0, 5)}  '
                      '${l10n.reportTaskDone(c.title, l10n.duration(c.reward))}',
                    ),
                  ),
                ],
              ),
            ),
          if (log.attempts.isEmpty && log.completions.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.reportNoActivity),
              ),
            ),
          for (final (i, a) in log.attempts.indexed)
            _AttemptTile(index: i, a: a),
        ],
      ),
    );
  }
}

class _AttemptTile extends StatelessWidget {
  const _AttemptTile({required this.index, required this.a});
  final int index;
  final QuestionAttempt a;

  @override
  Widget build(BuildContext context) {
    final color = a.isCorrect ? AppColors.success : AppColors.danger;
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                a.isCorrect ? Icons.check_circle : Icons.cancel,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.reportAttemptTitle(index + 1, a.subject, a.topic),
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                formatTime(a.answeredAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            a.questionText,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.reportChosenAnswer(
              optionLetters[a.chosenIndex],
              a.options[a.chosenIndex],
            ),
          ),
          if (!a.isCorrect) ...[
            Text(
              l10n.reportCorrectAnswer(
                optionLetters[a.correctIndex],
                a.options[a.correctIndex],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '💡 ${a.suggestion}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
