import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/info_row.dart';
import 'privacy_policy_screen.dart';

/// Màn đồng ý lần đầu: chỉ phụ huynh xác nhận trước khi dùng app.
class ParentConsentScreen extends StatefulWidget {
  const ParentConsentScreen({super.key, required this.onAccepted});

  final VoidCallback onAccepted;

  @override
  State<ParentConsentScreen> createState() => _ParentConsentScreenState();
}

class _ParentConsentScreenState extends State<ParentConsentScreen> {
  bool _busy = false;

  Future<void> _accept() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await DependenciesScope.of(context).parentConsent.accept();
      if (mounted) widget.onAccepted();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                children: [
                  const _BrandBadge(),
                  const SizedBox(height: 20),
                  Text(
                    l10n.consentTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.consentIntro,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  InfoCard(
                    rows: [
                      InfoRow(
                        icon: Icons.family_restroom_rounded,
                        title: l10n.consentParentTitle,
                        body: l10n.consentParentBody,
                      ),
                      InfoRow(
                        icon: Icons.phone_iphone_rounded,
                        color: AppColors.success,
                        title: l10n.consentLocalTitle,
                        body: l10n.consentLocalBody,
                      ),
                      InfoRow(
                        icon: Icons.child_care_rounded,
                        color: AppColors.kidDeep,
                        title: l10n.consentChildTitle,
                        body: l10n.consentChildBody,
                      ),
                      InfoRow(
                        icon: Icons.cloud_download_rounded,
                        color: AppColors.textSecondary,
                        title: l10n.consentNetworkTitle,
                        body: l10n.consentNetworkBody,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Nút cố định ở cuối màn, luôn trong tầm ngón cái.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: _busy ? null : _accept,
                    child: _busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(l10n.consentAgree),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    ),
                    child: Text(l10n.consentReadPolicy),
                  ),
                  Text(
                    l10n.consentFootnote,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Biểu tượng KidGuard trên nền xanh chuyển màu.
class _BrandBadge extends StatelessWidget {
  const _BrandBadge();

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6E86F5), AppColors.primary],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.shield_moon_rounded,
        color: Colors.white,
        size: 40,
      ),
    ),
  );
}
