import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/repositories/repositories.dart';
import '../l10n_ext.dart';
import '../widgets/dependencies_scope.dart';
import '../widgets/parent_auth_flow.dart';
import 'child/child_register_screen.dart';
import 'parent/advanced_lock_screen.dart';
import 'parent/parent_dashboard_screen.dart';
import 'setup/privacy_policy_screen.dart';
import 'setup/settings_walkthrough.dart';
import 'setup/setup_steps.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  DevicePermissions? _perms;
  bool? _lockAvailable;

  /// Các mục người lớn đã xác nhận bật (hệ thống không cho app tự kiểm tra).
  Set<String> _confirmed = const {};

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
    // Quay lại từ màn Cài đặt cấp quyền → cập nhật trạng thái.
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _refresh() async {
    final deps = DependenciesScope.of(context);
    final perms = await deps.device.getPermissions();
    final lock = await deps.parentAuth.isAvailable();
    final confirmed = await deps.setupChecklist.getConfirmed();
    if (mounted) {
      setState(() {
        _perms = perms;
        _lockAvailable = lock;
        _confirmed = confirmed;
      });
    }
  }

  /// Hướng dẫn trước → mở Cài đặt → hỏi đã bật chưa → ghi nhớ.
  Future<void> _walkthrough(
    SetupGuide guide,
    Future<void> Function()? openSettings, {
    String? confirmKey,
  }) async {
    final checklist = DependenciesScope.of(context).setupChecklist;
    final confirmed = await runSettingsWalkthrough(
      context,
      guide: guide,
      openSettings: openSettings,
      askConfirm: confirmKey != null,
    );
    if (confirmed && confirmKey != null) {
      await checklist.setConfirmed(confirmKey, true);
    }
    await _refresh();
  }

  Future<void> _openParentArea() async {
    final parent = DependenciesScope.of(context).parentController;
    final result = await parent.authenticate(
      reason: context.l10n.authReasonParentArea,
    );
    if (!mounted) return;
    if (result != ParentAuthResult.success) {
      showParentAuthMessage(context, result);
      return;
    }
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ParentDashboardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final device = DependenciesScope.of(context).device;
    final perms = _perms;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.shield_moon_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'KidGuard',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _HeroCard(
              onStart: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChildRegisterScreen()),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8ECFD),
                  child: Icon(Icons.insights_rounded, color: AppColors.primary),
                ),
                title: Text(
                  l10n.homeParentArea,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(l10n.homeParentAreaSubtitle),
                trailing: const Icon(Icons.lock_outline_rounded),
                onTap: _openParentArea,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.homeSetupHeader,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            _SetupTile(
              ok: _lockAvailable ?? false,
              loading: _lockAvailable == null,
              title: l10n.homeScreenLockTitle,
              subtitle: l10n.homeScreenLockSubtitle,
            ),
            if (perms != null && perms.platform == DevicePlatform.android) ...[
              _InfoCard(text: l10n.homeAndroidNotice),
              _SetupTile(
                ok: perms.overlay,
                title: l10n.setupOverlayTitle,
                subtitle: l10n.homeOverlaySubtitle,
                onFix: () => _walkthrough(
                  overlayGuide(l10n, perms.oem),
                  device.requestOverlayPermission,
                ),
              ),
              if (perms.oem.hasBackgroundPopupPermission)
                _SetupTile(
                  ok: _confirmed.contains('background_popup'),
                  unknown: true,
                  title: l10n.homePopupTitle,
                  subtitle: _confirmed.contains('background_popup')
                      ? l10n.homeConfirmedOn
                      : l10n.homePopupSubtitle(perms.oem.brandName),
                  fixLabel: _confirmed.contains('background_popup')
                      ? l10n.homeReview
                      : l10n.homeGuide,
                  showActionWhenOk: true,
                  onFix: () => _walkthrough(
                    backgroundPopupGuide(l10n, perms.oem),
                    device.openBackgroundPopupSettings,
                    confirmKey: 'background_popup',
                  ),
                ),
              _SetupTile(
                ok: perms.notifications,
                title: l10n.homeNotificationsTitle,
                subtitle: l10n.homeNotificationsSubtitle,
                onFix: device.requestNotificationPermission,
              ),
              _SetupTile(
                ok: perms.batteryUnrestricted,
                title: l10n.homeBatteryTitle,
                subtitle: l10n.homeBatterySubtitle,
                onFix: device.requestIgnoreBatteryOptimizations,
              ),
              if (perms.oem.hasAutoStart)
                _SetupTile(
                  ok: _confirmed.contains('autostart'),
                  unknown: true,
                  title: l10n.setupAutoStartTitle,
                  subtitle: _confirmed.contains('autostart')
                      ? l10n.homeConfirmedOn
                      : l10n.homeAutoStartSubtitle,
                  fixLabel: _confirmed.contains('autostart')
                      ? l10n.homeReview
                      : l10n.homeGuide,
                  showActionWhenOk: true,
                  onFix: () => _walkthrough(
                    autoStartGuide(l10n, perms.oem),
                    // ColorOS 12+ đã bỏ màn "Tự khởi động" riêng; mục này nằm trong
                    // Thông tin ứng dụng › Mức sử dụng pin.
                    perms.oem == OemFamily.oppo
                        ? device.openAppSettings
                        : device.openAutoStartSettings,
                    confirmKey: 'autostart',
                  ),
                ),
              if (perms.oem != OemFamily.other)
                _SetupTile(
                  ok: _confirmed.contains('recents_lock'),
                  unknown: true,
                  title: l10n.setupRecentsTitle,
                  subtitle: _confirmed.contains('recents_lock')
                      ? l10n.homeConfirmedLocked
                      : l10n.homeRecentsSubtitle,
                  fixLabel: _confirmed.contains('recents_lock')
                      ? l10n.homeReview
                      : l10n.homeGuide,
                  showActionWhenOk: true,
                  onFix: () => _walkthrough(
                    recentsLockGuide(l10n, perms.oem),
                    null,
                    confirmKey: 'recents_lock',
                  ),
                ),
              _SetupTile(
                ok: perms.accessibility,
                optional: true,
                title: l10n.homeAdvancedLockTitle,
                subtitle: perms.accessibility
                    ? l10n.homeAdvancedLockOn
                    : l10n.homeAdvancedLockOff,
                fixLabel: perms.accessibility
                    ? l10n.homeManage
                    : l10n.homeGuide,
                showActionWhenOk: true,
                onFix: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdvancedLockScreen(),
                    ),
                  );
                  _refresh();
                },
              ),
            ],
            if (perms != null && perms.platform == DevicePlatform.ios) ...[
              _SetupTile(
                ok: perms.screenTimeAuthorized,
                title: l10n.homeScreenTimeTitle,
                subtitle: l10n.homeScreenTimeSubtitle,
                onFix: () async {
                  await device.requestScreenTimeAuthorization();
                  await _refresh();
                },
              ),
              _SetupTile(
                ok: perms.limitedAppsSelected,
                title: l10n.homeLimitedAppsTitle,
                subtitle: !perms.screenTimeAuthorized
                    ? l10n.homeScreenTimeFirst
                    : perms.limitedAppsSelected
                    ? l10n.homeLimitedAppsOn
                    : l10n.homeLimitedAppsSubtitle,
                fixLabel: perms.limitedAppsSelected
                    ? l10n.homeLimitedAppsChange
                    : l10n.homeLimitedAppsChoose,
                showActionWhenOk: true,
                onFix: perms.screenTimeAuthorized
                    ? () async {
                        await device.chooseLimitedApps();
                        await _refresh();
                      }
                    : null,
              ),
              _InfoCard(text: l10n.homeIosNotice),
            ],
            if (perms != null && perms.platform.isDesktop)
              _InfoCard(
                title: l10n.homeDesktopTitle,
                text: perms.platform == DevicePlatform.macos
                    ? l10n.homeMacNotice
                    : '${l10n.homeWindowsNotice}\n\n${l10n.homeWindowsHelloHint}',
              ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              ),
              child: Text(l10n.homePrivacyPolicy),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB166), AppColors.kid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.homeHeroTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ListenableBuilder(
            listenable: DependenciesScope.of(context).settingsController,
            builder: (context, _) => Text(
              context.l10n.homeHeroBody(
                context.l10n.duration(
                  DependenciesScope.of(
                    context,
                  ).settingsController.initialAllowance,
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.kid,
            ),
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(context.l10n.homeStartKidMode),
          ),
        ],
      ),
    );
  }
}

class _SetupTile extends StatelessWidget {
  const _SetupTile({
    required this.ok,
    required this.title,
    required this.subtitle,
    this.onFix,
    this.optional = false,
    this.loading = false,
    this.unknown = false,
    this.fixLabel,
    this.showActionWhenOk = false,
  });

  final bool showActionWhenOk;

  final bool ok;
  final bool optional;
  final bool loading;

  /// Không kiểm tra được trạng thái → luôn hiện nút mở cài đặt.
  final bool unknown;

  /// null = "Cấp quyền" / "Grant".
  final String? fixLabel;
  final String title;
  final String subtitle;
  final VoidCallback? onFix;

  @override
  Widget build(BuildContext context) {
    final color = ok
        ? AppColors.success
        : optional || unknown
        ? Colors.grey
        : AppColors.danger;
    final icon = ok
        ? Icons.check_circle_rounded
        : unknown
        ? Icons.settings_suggest_rounded
        : Icons.error_rounded;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: loading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(icon, color: color),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(subtitle),
          trailing: (!ok || showActionWhenOk) && onFix != null
              ? TextButton(
                  onPressed: onFix,
                  child: Text(fixLabel ?? context.l10n.homeGrant),
                )
              : null,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.text, this.title});
  final String text;
  final String? title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 8),
    child: Card(
      color: const Color(0xFFEFF3FF),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline_rounded, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(text, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
