import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../l10n_ext.dart';

/// Bản tóm tắt chính sách trong app + URL công khai để phụ huynh / store đối chiếu.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Future<void> _copyUrl(BuildContext context) async {
    await Clipboard.setData(
      const ClipboardData(text: AppConstants.privacyPolicyUrl),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.privacyUrlCopied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Text(l10n.privacyBody, style: theme.textTheme.bodyLarge?.copyWith(height: 1.45)),
          const SizedBox(height: 24),
          Text(
            l10n.privacyOnlineLabel,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SelectableText(
            AppConstants.privacyPolicyUrl,
            style: const TextStyle(color: AppColors.primary, height: 1.4),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _copyUrl(context),
            icon: const Icon(Icons.copy_rounded),
            label: Text(l10n.privacyCopyUrl),
          ),
        ],
      ),
    );
  }
}
