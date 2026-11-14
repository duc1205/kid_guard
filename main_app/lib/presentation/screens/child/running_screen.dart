import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/parent_revoke_button.dart';

/// Trẻ đang được dùng máy: hiển thị đồng hồ đếm ngược.
class RunningScreen extends StatelessWidget {
  const RunningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DependenciesScope.of(context).guardController;
    final session = controller.session!;
    final l10n = context.l10n;
    // Độ dài lượt hiện tại: 15 phút (lượt đầu) hoặc 5 phút (thưởng).
    final start = session.segmentStartedAt;
    final total = start == null
        ? AppConstants.initialAllowance
        : session.endsAt.difference(start);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.kid.withValues(alpha: 0.15),
                    child: Text(
                      session.child.name.characters.first.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: AppColors.kid,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.runningGreeting(session.child.name),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          l10n.runningGrade(
                            l10n.gradeLabel(session.child.grade),
                          ),
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Chỉ phần đồng hồ được vẽ lại mỗi giây.
              ValueListenableBuilder<DateTime>(
                valueListenable: controller.clockTick,
                builder: (context, now, _) {
                  final remaining = session.remaining(now);
                  final progress = total.inMilliseconds <= 0
                      ? 0.0
                      : (remaining.inMilliseconds / total.inMilliseconds).clamp(
                          0.0,
                          1.0,
                        );
                  final warn = remaining < const Duration(minutes: 1);
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
                          color: warn ? AppColors.danger : AppColors.success,
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l10n.runningTimeLeft,
                                style: const TextStyle(color: Colors.black54),
                              ),
                              Text(
                                formatCountdown(remaining),
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
                l10n.runningRules,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
              const Spacer(),
              // iOS không cho app tự đẩy mình xuống nền → chỉ hướng dẫn bé vuốt lên.
              if (Theme.of(context).platform == TargetPlatform.iOS)
                Text(
                  l10n.runningIosHint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                )
              else
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.kid),
                  onPressed: controller.useOtherApps,
                  icon: const Icon(Icons.apps_rounded),
                  label: Text(l10n.runningUseOtherApps),
                ),
              const SizedBox(height: 8),
              const ParentRevokeButton(color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
