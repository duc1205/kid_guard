import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/usecases/parent_usecases.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/stat_tile.dart';
import 'child_report_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final controller = DependenciesScope.of(context).parentController;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardTitle)),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.loading && controller.reports.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final reports = controller.reports;
          if (reports.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.dashboardEmpty,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
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
                      '${l10n.dashboardChildInfo(c.grade, c.ageAt(DateTime.now()))}'
                      '${last == null ? '' : ' · ${formatDateTime(last)}'}',
                      style: const TextStyle(color: Colors.black54),
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
