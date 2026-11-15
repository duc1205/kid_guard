import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../domain/usecases/parent_usecases.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/parent_auth_flow.dart';
import '../../widgets/stat_tile.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/usecases/settings_usecases.dart';
import 'child_report_screen.dart';
import 'question_source_screen.dart';

/// Khu vực phụ huynh: danh sách các bé đã dùng máy và thống kê tổng quan.
class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    DependenciesScope.of(context).parentController.load();
  }

  Future<void> _clearAllData() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.clearAllDataTitle),
        content: Text(l10n.clearAllDataBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.clearAllDataConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final parent = DependenciesScope.of(context).parentController;
    final auth = await parent.authenticate(reason: l10n.authReasonClearAllData);
    if (!mounted) return;
    if (auth != ParentAuthResult.success) {
      showParentAuthMessage(context, auth);
      return;
    }
    try {
      await parent.clearAllChildrenData();
    } on ActiveSessionExistsException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteBlockedActiveSession)),
      );
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.clearAllDataDone)));
  }

  @override
  Widget build(BuildContext context) {
    final controller = DependenciesScope.of(context).parentController;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
        actions: [
          IconButton(
            tooltip: l10n.dashboardQuestionSource,
            icon: const Icon(Icons.library_books_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuestionSourceScreen()),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.loading && controller.reports.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final reports = controller.reports;
          if (reports.isEmpty) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                const _InitialAllowanceCard(),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    l10n.dashboardEmpty,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                  ),
                ),
              ],
            );
          }
          final totalTime = reports.fold(
            Duration.zero,
            (s, r) => s + r.stats.totalUsed,
          );
          final correct = reports.fold(0, (s, r) => s + r.stats.correct);
          final wrong = reports.fold(0, (s, r) => s + r.stats.wrong);
          return RefreshIndicator(
            onRefresh: controller.load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                const _InitialAllowanceCard(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        label: l10n.dashboardTotalTime,
                        value: l10n.duration(totalTime),
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatTile(
                        label: l10n.dashboardCorrect,
                        value: '$correct',
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatTile(
                        label: l10n.dashboardWrong,
                        value: '$wrong',
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.dashboardChildren,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                for (final r in reports) ...[
                  _ChildCard(report: r),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
                  onPressed: _clearAllData,
                  icon: const Icon(Icons.delete_forever_rounded),
                  label: Text(l10n.clearAllDataButton),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  const _ChildCard({required this.report});
  final ChildReport report;

  @override
  Widget build(BuildContext context) {
    final c = report.child;
    final last = report.stats.lastUsedAt;
    final l10n = context.l10n;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ChildReportScreen(report: report)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.kid.withValues(alpha: 0.15),
                child: Text(
                  c.name.characters.first.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.kid,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${l10n.dashboardChildInfo(l10n.gradeLabel(c.grade), c.ageAt(DateTime.now()))}'
                      '${last == null ? '' : ' · ${formatDateTime(last)}'}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${l10n.duration(report.stats.totalUsed)} · '
                      '✅ ${report.stats.correct}  ❌ ${report.stats.wrong}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thời gian dùng máy ban đầu của mỗi phiên (mặc định 15 phút, tối thiểu 5 phút).
class _InitialAllowanceCard extends StatelessWidget {
  const _InitialAllowanceCard();

  @override
  Widget build(BuildContext context) {
    final settings = DependenciesScope.of(context).settingsController;
    final l10n = context.l10n;
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) {
        final value = l10n.duration(settings.initialAllowance);
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: const Icon(Icons.timer_rounded, color: AppColors.primary),
            title: Text(
              l10n.settingsInitialAllowance,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              settings.isDefault
                  ? l10n.settingsInitialAllowanceDefault(value)
                  : value,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            trailing: const Icon(Icons.edit_rounded),
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => const _InitialAllowanceDialog(),
            ),
          ),
        );
      },
    );
  }
}

class _InitialAllowanceDialog extends StatefulWidget {
  const _InitialAllowanceDialog();

  @override
  State<_InitialAllowanceDialog> createState() =>
      _InitialAllowanceDialogState();
}

class _InitialAllowanceDialogState extends State<_InitialAllowanceDialog> {
  late final _minutes = TextEditingController(
    text:
        '${DependenciesScope.of(context).settingsController.initialAllowance.inMinutes}',
  );
  String? _error;

  @override
  void dispose() {
    _minutes.dispose();
    super.dispose();
  }

  Future<void> _apply(Duration? value) async {
    final settings = DependenciesScope.of(context).settingsController;
    try {
      await settings.setInitialAllowance(value);
      if (mounted) Navigator.of(context).pop();
    } on InitialAllowanceTooShortException {
      setState(
        () => _error = context.l10n.settingsMinutesMin(
          AppConstants.minInitialAllowance.inMinutes,
        ),
      );
    }
  }

  void _save() {
    final l10n = context.l10n;
    final minutes = int.tryParse(_minutes.text.trim());
    if (minutes == null) {
      setState(() => _error = l10n.settingsMinutesInvalid);
      return;
    }
    if (minutes < AppConstants.minInitialAllowance.inMinutes) {
      setState(
        () => _error = l10n.settingsMinutesMin(
          AppConstants.minInitialAllowance.inMinutes,
        ),
      );
      return;
    }
    _apply(Duration(minutes: minutes));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.settingsInitialAllowance),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.settingsInitialAllowanceHint),
          const SizedBox(height: 16),
          TextField(
            controller: _minutes,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.settingsMinutesLabel,
              helperText: l10n.settingsMinutesMin(
                AppConstants.minInitialAllowance.inMinutes,
              ),
              errorText: _error,
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _apply(null),
            child: Text(
              l10n.settingsResetDefault(
                l10n.duration(AppConstants.defaultInitialAllowance),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.settingsCancel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.settingsSave)),
      ],
    );
  }
}
