import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          children: [
            const Icon(
              Icons.family_restroom_rounded,
              size: 48,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.consentTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.consentIntro, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 20),
            _Bullet(l10n.consentBulletParent),
            _Bullet(l10n.consentBulletLocal),
            _Bullet(l10n.consentBulletChildData),
            _Bullet(l10n.consentBulletNetwork),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              ),
              child: Text(l10n.consentReadPolicy),
            ),
            const SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
      ],
    ),
  );
}
