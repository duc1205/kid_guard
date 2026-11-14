import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/repositories/repositories.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/parent_auth_flow.dart';

const _setOwnerCommand =
    'adb shell dpm set-device-owner com.pham.kidguard/.KidGuardAdminReceiver';

/// Hướng dẫn bật "Khoá cứng" (Device Owner) từng bước + nút gỡ.
class HardLockGuideScreen extends StatefulWidget {
  const HardLockGuideScreen({super.key});

  @override
  State<HardLockGuideScreen> createState() => _HardLockGuideScreenState();
}

class _HardLockGuideScreenState extends State<HardLockGuideScreen>
    with WidgetsBindingObserver {
  DevicePermissions? _perms;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final p = await DependenciesScope.of(context).device.getPermissions();
    if (mounted) setState(() => _perms = p);
  }

  Future<void> _disable() async {
    final deps = DependenciesScope.of(context);
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.hardLockDisableTitle),
        content: Text(l10n.hardLockDisableBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.hardLockCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.hardLockTurnOff),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    final auth = await deps.parentController.authenticate(
      reason: l10n.authReasonDisableHardLock,
    );
    if (!mounted) return;
    if (auth != ParentAuthResult.success) {
      setState(() => _busy = false);
      showParentAuthMessage(context, auth);
      return;
    }
    final ok = await deps.device.clearDeviceOwner();
    await _refresh();
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? l10n.hardLockDisabledOk : l10n.hardLockDisableFailed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final perms = _perms;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.hardLockTitle)),
      body: perms == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
              children: [
                _StatusCard(enabled: perms.deviceOwner),
                const SizedBox(height: 16),
                if (perms.deviceOwner)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                    ),
                    onPressed: _busy ? null : _disable,
                    icon: const Icon(Icons.lock_open_rounded),
                    label: Text(context.l10n.hardLockDisableButton),
                  )
                else
                  ..._guide(perms.oem),
              ],
            ),
    );
  }

  List<Widget> _guide(OemFamily oem) {
    final l10n = context.l10n;
    final dev = _devOptions(l10n, oem);
    return [
      Text(l10n.hardLockIntro, style: const TextStyle(color: Colors.black54)),
      const SizedBox(height: 16),
      _Section(
        number: 1,
        title: l10n.hardLockStep1Title,
        children: [
          _Bullet(dev.enable),
          _Bullet(l10n.hardLockStep1UsbDebugging(dev.location)),
          if (dev.extra != null) _Bullet(dev.extra!, highlight: true),
        ],
      ),
      _Section(
        number: 2,
        title: l10n.hardLockStep2Title,
        children: [
          _Bullet(l10n.hardLockStep2Accounts),
          _Bullet(dev.extraUsers),
          _Bullet(l10n.hardLockStep2NoDataLoss, highlight: true),
        ],
      ),
      _Section(
        number: 3,
        title: l10n.hardLockStep3Title,
        children: [
          _Bullet(l10n.hardLockStep3Mac),
          const _CommandBox('brew install --cask android-platform-tools'),
          _Bullet(l10n.hardLockStep3Windows),
          _Bullet(l10n.hardLockStep3Plug),
          _Bullet(l10n.hardLockStep3Check),
          const _CommandBox('adb devices'),
        ],
      ),
      _Section(
        number: 4,
        title: l10n.hardLockStep4Title,
        children: [
          _Bullet(l10n.hardLockStep4Run),
          const _CommandBox(_setOwnerCommand),
          _Bullet(l10n.hardLockStep4Success, highlight: true),
          _Bullet(l10n.hardLockStep4After),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        l10n.hardLockTroubleTitle,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 8),
      _ErrorTile(
        error: '…already some accounts on the device',
        fix: l10n.hardLockErrAccountsFix,
      ),
      _ErrorTile(
        error: '…already several users on the device',
        fix: dev.extraUsers,
      ),
      _ErrorTile(
        error: 'SecurityException / MANAGE_DEVICE_ADMINS / not allowed',
        fix: dev.extra ?? l10n.hardLockErrSecurityFix,
      ),
      _ErrorTile(
        error: 'Unknown admin / Bad component name',
        fix: l10n.hardLockErrUnknownAdminFix,
      ),
      _ErrorTile(
        error: l10n.hardLockErrNoDevice,
        fix: l10n.hardLockErrNoDeviceFix,
      ),
      _ErrorTile(
        error: 'command not found: adb',
        fix: l10n.hardLockErrNoAdbFix,
      ),
    ];
  }
}

class _DevOptions {
  const _DevOptions(this.enable, this.location, this.extraUsers, [this.extra]);
  final String enable;
  final String location;
  final String extraUsers;
  final String? extra;
}

_DevOptions _devOptions(AppLocalizations l10n, OemFamily oem) => switch (oem) {
  OemFamily.oppo => _DevOptions(
    l10n.hardLockDevOppoEnable,
    l10n.hardLockDevLocationAdditional,
    l10n.hardLockDevOppoUsers,
    l10n.hardLockDevOppoExtra,
  ),
  OemFamily.xiaomi => _DevOptions(
    l10n.hardLockDevXiaomiEnable,
    l10n.hardLockDevLocationAdditional,
    l10n.hardLockDevXiaomiUsers,
    l10n.hardLockDevXiaomiExtra,
  ),
  OemFamily.vivo => _DevOptions(
    l10n.hardLockDevVivoEnable,
    l10n.hardLockDevLocationSystem,
    l10n.hardLockDevVivoUsers,
  ),
  OemFamily.samsung => _DevOptions(
    l10n.hardLockDevSamsungEnable,
    l10n.hardLockDevSamsungLocation,
    l10n.hardLockDevSamsungUsers,
  ),
  OemFamily.huawei => _DevOptions(
    l10n.hardLockDevGenericEnable,
    l10n.hardLockDevHuaweiLocation,
    l10n.hardLockDevHuaweiUsers,
  ),
  OemFamily.other => _DevOptions(
    l10n.hardLockDevGenericEnable,
    l10n.hardLockDevLocationSystem,
    l10n.hardLockDevOtherUsers,
  ),
};

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.enabled});
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppColors.success : AppColors.kid;
    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  enabled ? Icons.verified_user_rounded : Icons.shield_outlined,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  enabled
                      ? context.l10n.hardLockStatusOn
                      : context.l10n.hardLockStatusOff,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              enabled
                  ? context.l10n.hardLockStatusOnBody
                  : context.l10n.hardLockStatusOffBody,
              style: const TextStyle(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.number,
    required this.title,
    required this.children,
  });
  final int number;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    ),
  );
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text, {this.highlight = false});
  final String text;
  final bool highlight;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            highlight ? Icons.priority_high_rounded : Icons.circle,
            size: highlight ? 16 : 7,
            color: highlight ? AppColors.kid : Colors.black45,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              height: 1.4,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    ),
  );
}

class _CommandBox extends StatelessWidget {
  const _CommandBox(this.command);
  final String command;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10, left: 16),
    padding: const EdgeInsets.fromLTRB(12, 6, 4, 6),
    decoration: BoxDecoration(
      color: const Color(0xFF1E2140),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: SelectableText(
            command,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 13,
            ),
          ),
        ),
        IconButton(
          tooltip: context.l10n.hardLockCopy,
          icon: const Icon(Icons.copy_rounded, color: Colors.white70),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: command));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.hardLockCopied)),
              );
            }
          },
        ),
      ],
    ),
  );
}

class _ErrorTile extends StatelessWidget {
  const _ErrorTile({required this.error, required this.fix});
  final String error;
  final String fix;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        leading: const Icon(
          Icons.error_outline_rounded,
          color: AppColors.danger,
        ),
        title: Text(
          error,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        expandedAlignment: Alignment.centerLeft,
        children: [Text(fix, style: const TextStyle(height: 1.4))],
      ),
    ),
  );
}
