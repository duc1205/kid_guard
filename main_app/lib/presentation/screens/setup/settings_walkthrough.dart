import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../l10n_ext.dart';
import 'setup_steps.dart';

/// Quy trình 3 bước cho các mục phải bật trong Cài đặt của máy:
/// 1. Hiện hướng dẫn TRƯỚC khi rời app (vì trang Cài đặt sẽ che mất app).
/// 2. Mở Cài đặt, chờ người dùng quay lại.
/// 3. Nếu [askConfirm]: hỏi "Đã bật xong chưa?" — trả về true nếu xác nhận.
Future<bool> runSettingsWalkthrough(
  BuildContext context, {
  required SetupGuide guide,

  /// null = thao tác không nằm trong Cài đặt (vd. khoá app trong đa nhiệm).
  required Future<void> Function()? openSettings,
  bool askConfirm = true,
}) async {
  final go = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) =>
        _GuideSheet(guide: guide, opensSettings: openSettings != null),
  );
  if (go != true || !context.mounted) return false;

  if (openSettings != null) {
    final returned = _waitForReturn();
    await openSettings();
    await returned;
  }
  if (!askConfirm || !context.mounted) return false;

  final answer = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(guide.title),
      content: Text(ctx.l10n.setupConfirmQuestion),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, 'again'),
          child: Text(ctx.l10n.setupConfirmAgain),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, 'done'),
          child: Text(ctx.l10n.setupConfirmDone),
        ),
      ],
    ),
  );
  if (answer == 'done') return true;
  if (answer != 'again' || !context.mounted) return false;
  return runSettingsWalkthrough(
    context,
    guide: guide,
    openSettings: openSettings,
  );
}

/// Hoàn tất khi app quay lại foreground sau khi đã rời đi. Nếu sau 3 giây
/// app vẫn chưa rời đi (máy không mở được Cài đặt) thì hoàn tất luôn.
Future<void> _waitForReturn() {
  final done = Completer<void>();
  var left = false;
  late final AppLifecycleListener listener;
  void finish() {
    if (!done.isCompleted) {
      listener.dispose();
      done.complete();
    }
  }

  listener = AppLifecycleListener(
    onHide: () => left = true,
    onPause: () => left = true,
    onResume: () {
      if (left) finish();
    },
  );
  Future.delayed(const Duration(seconds: 3), () {
    if (!left) finish();
  });
  return done.future;
}

class _GuideSheet extends StatelessWidget {
  const _GuideSheet({required this.guide, required this.opensSettings});
  final SetupGuide guide;
  final bool opensSettings;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              guide.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              opensSettings
                  ? context.l10n.setupReadStepsFirst
                  : context.l10n.setupFollowSteps,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            for (final (i, step) in guide.steps.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step,
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            if (guide.note != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: Color(0xFFF5A623),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        guide.note!,
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: Icon(
                opensSettings ? Icons.open_in_new_rounded : Icons.check_rounded,
              ),
              label: Text(
                opensSettings
                    ? context.l10n.setupOpenSettings
                    : context.l10n.setupGotIt,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
