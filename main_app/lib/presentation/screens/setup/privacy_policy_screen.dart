import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../l10n_ext.dart';
import '../../widgets/info_row.dart';

/// Bản tóm tắt chính sách trong app + URL công khai để phụ huynh / store đối chiếu.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Future<void> _copyUrl(BuildContext context) async {
    await Clipboard.setData(
      const ClipboardData(text: AppConstants.privacyPolicyUrl),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.privacyUrlCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          Text(
            l10n.privacyIntro,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          InfoCard(
            rows: [
              InfoRow(
                icon: Icons.phone_iphone_rounded,
                color: AppColors.success,
                title: l10n.privacyStoreTitle,
                body: l10n.privacyStoreBody,
              ),
              InfoRow(
                icon: Icons.delete_outline_rounded,
                color: AppColors.danger,
                title: l10n.privacyDeleteTitle,
                body: l10n.privacyDeleteBody,
              ),
              InfoRow(
                icon: Icons.lock_outline_rounded,
                title: l10n.privacyUnlockTitle,
                body: l10n.privacyUnlockBody,
              ),
              InfoRow(
                icon: Icons.admin_panel_settings_outlined,
                color: AppColors.kidDeep,
                title: l10n.privacyPermissionsTitle,
                body: l10n.privacyPermissionsBody,
              ),
              InfoRow(
                icon: Icons.cloud_off_rounded,
                color: AppColors.textSecondary,
                title: l10n.privacyNetworkTitle,
                body: l10n.privacyNetworkBody,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.description_outlined,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.privacyFullTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    AppConstants.privacyPolicyUrl,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                    ),
                    onPressed: () => _copyUrl(context),
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: Text(l10n.privacyCopyUrl),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
