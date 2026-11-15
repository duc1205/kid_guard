import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/parent_revoke_button.dart';

/// Hết giờ / bị khoá — chỉ người lớn nhập đúng mật khẩu máy mới mở được.
/// Trên iOS chỉ chặn app phụ huynh chọn, không khoá cả máy → chữ riêng.
class LockedScreen extends StatelessWidget {
  const LockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = DependenciesScope.of(context).guardController.session!;
    final l10n = context.l10n;
    final ios = Theme.of(context).platform == TargetPlatform.iOS;
    final title = ios ? l10n.lockedTitleIos : l10n.lockedTitle;
    final message = ios
        ? l10n.lockedMessageIos(session.child.name)
        : l10n.lockedMessage(session.child.name);
    return Scaffold(
      backgroundColor: AppColors.lockedBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  size: 72,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.45,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ParentRevokeButton(
                  filled: true,
                  label: l10n.lockedUnlockButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
