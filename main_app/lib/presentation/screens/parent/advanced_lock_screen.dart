import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/repositories/repositories.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/parent_auth_flow.dart';

/// "Khoá nâng cao": hướng dẫn bật Trợ năng của KidGuard ngay trên máy (không cần
/// máy tính). Máy nào còn bật khoá cứng cũ (Device Owner) thì có nút tắt để gỡ app.
class AdvancedLockScreen extends StatefulWidget {
  const AdvancedLockScreen({super.key});

  @override
  State<AdvancedLockScreen> createState() => _AdvancedLockScreenState();
}

class _AdvancedLockScreenState extends State<AdvancedLockScreen>
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
    // Quay lại từ màn Cài đặt → cập nhật trạng thái.
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final p = await DependenciesScope.of(context).device.getPermissions();
    if (mounted) setState(() => _perms = p);
  }

  /// Play: công bố nổi bật + đồng ý rõ ràng trước khi mở Cài đặt › Trợ năng.
  Future<void> _openAccessibilitySettingsToEnable() async {
    final l10n = context.l10n;
    final agreed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.advancedLockDisclosureTitle),
        content: SingleChildScrollView(
          child: Text(l10n.advancedLockDisclosureBody),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.advancedLockAgreeContinue),
          ),
        ],
      ),
    );
    if (agreed != true || !mounted) return;
    await DependenciesScope.of(context).device.openAccessibilitySettings();
  }

  Future<void> _disableLegacyHardLock() async {
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
    final l10n = context.l10n;
    final device = DependenciesScope.of(context).device;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.advancedLockTitle)),
      body: perms == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
              children: [
                _StatusCard(enabled: perms.accessibility),
                const SizedBox(height: 20),
                _Section(
                  title: l10n.advancedLockWhatTitle,
                  children: [
                    _Bullet(l10n.advancedLockWhat1),
                    _Bullet(l10n.advancedLockWhat2),
                    _Bullet(l10n.advancedLockWhat3),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.advancedLockPrivacy,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),
                if (perms.accessibility)
                  _Section(
                    title: l10n.advancedLockOffNote,
                    children: [
                      OutlinedButton.icon(
                        onPressed: device.openAccessibilitySettings,
                        icon: const Icon(Icons.accessibility_new_rounded),
                        label: Text(l10n.advancedLockOpenSettings),
                      ),
                    ],
                  )
                else
                  _Section(
                    title: l10n.advancedLockStepsTitle,
                    children: [
                      if (perms.androidSdk >= 33) ...[
                        _Bullet(l10n.advancedLockStepRestricted, number: 1),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, bottom: 12),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton.icon(
                              onPressed: device.openAppSettings,
                              icon: const Icon(Icons.info_outline_rounded),
                              label: Text(l10n.advancedLockOpenAppInfo),
                            ),
                          ),
                        ),
                      ],
                      _Bullet(
                        l10n.advancedLockStepEnable,
                        number: perms.androidSdk >= 33 ? 2 : 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, bottom: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FilledButton.icon(
                            onPressed: _openAccessibilitySettingsToEnable,
                            icon: const Icon(Icons.accessibility_new_rounded),
                            label: Text(l10n.advancedLockOpenSettings),
                          ),
                        ),
                      ),
                      _Bullet(
                        l10n.advancedLockStepBack,
                        number: perms.androidSdk >= 33 ? 3 : 2,
                      ),
                    ],
                  ),
                if (perms.deviceOwner) ...[
                  const SizedBox(height: 24),
                  _Section(
                    title: l10n.legacyHardLockTitle,
                    children: [
                      Text(l10n.legacyHardLockBody),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                        ),
                        onPressed: _busy ? null : _disableLegacyHardLock,
                        icon: const Icon(Icons.lock_open_rounded),
                        label: Text(l10n.hardLockDisableButton),
                      ),
                    ],
                  ),
                ],
              ],
            ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.enabled});
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = enabled ? AppColors.success : AppColors.kid;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            enabled ? Icons.verified_user_rounded : Icons.shield_outlined,
            color: color,
            size: 32,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enabled
                      ? l10n.advancedLockStatusOn
                      : l10n.advancedLockStatusOff,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  enabled
                      ? l10n.advancedLockStatusOnBody
                      : l10n.advancedLockStatusOffBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
      const SizedBox(height: 10),
      ...children,
    ],
  );
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text, {this.number});
  final String text;
  final int? number;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          child: number == null
              ? const Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: Icon(Icons.circle, size: 7, color: Colors.black45),
                )
              : CircleAvatar(
                  radius: 11,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
        ),
        Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
      ],
    ),
  );
}
