import 'dart:io';

import 'package:flutter/services.dart';

import '../../domain/repositories/repositories.dart';

/// Cầu nối tới phần native của từng nền tảng (cùng tên channel, cùng giao thức):
/// - Android: SessionGuardService + MainActivity (Kotlin)
/// - iOS: Screen Time API — FamilyControls (`.child` / `.individual`) / ManagedSettings / DeviceActivity
/// - macOS: chế độ kiosk toàn màn hình (Swift)
/// - Windows: cửa sổ toàn màn hình luôn trên cùng + chặn phím hệ thống (C++)
/// Nền tảng khác: các lệnh là no-op.
class DeviceControlChannel implements DeviceControlRepository {
  DeviceControlChannel({MethodChannel? channel, DevicePlatform? platform})
    : _channel = channel ?? const MethodChannel('kidguard/device_control'),
      _platform = platform ?? _currentPlatform();

  final MethodChannel _channel;
  final DevicePlatform _platform;

  static DevicePlatform _currentPlatform() {
    if (Platform.isAndroid) return DevicePlatform.android;
    if (Platform.isIOS) return DevicePlatform.ios;
    if (Platform.isMacOS) return DevicePlatform.macos;
    if (Platform.isWindows) return DevicePlatform.windows;
    return DevicePlatform.other;
  }

  Future<T?> _call<T>(String method, [Map<String, Object?>? args]) async {
    if (_platform == DevicePlatform.other) return null;
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on MissingPluginException {
      // Lệnh chỉ có trên nền tảng khác (vd. quyền pin của Android trên iOS).
      return null;
    }
  }

  @override
  Future<void> startTimer(DateTime endsAt) =>
      _call('startTimer', {'endsAtMillis': endsAt.millisecondsSinceEpoch});

  @override
  Future<void> setGuard(bool enabled) =>
      _call('setGuard', {'enabled': enabled});

  @override
  Future<void> suspendGuard(bool suspended) =>
      _call('suspendGuard', {'suspended': suspended});

  @override
  Future<void> stop() => _call('stop');

  @override
  Future<void> moveToBackground() => _call('moveToBackground');

  @override
  Future<DevicePermissions> getPermissions() async {
    if (_platform == DevicePlatform.other) {
      return const DevicePermissions(
        overlay: false,
        notifications: false,
        deviceOwner: false,
        supported: false,
      );
    }
    final map =
        await _channel.invokeMapMethod<String, Object?>('permissionStatus') ??
        {};
    bool flag(String key) => map[key] == true;
    return DevicePermissions(
      platform: _platform,
      overlay: flag('overlay'),
      notifications: flag('notifications'),
      deviceOwner: flag('deviceOwner'),
      accessibility: flag('accessibility'),
      androidSdk: (map['sdkInt'] as int?) ?? 0,
      batteryUnrestricted: flag('batteryUnrestricted'),
      manufacturer: (map['manufacturer'] as String?) ?? '',
      screenTimeAuthorized: flag('screenTimeAuthorized'),
      limitedAppsSelected: flag('limitedAppsSelected'),
      supported: true,
    );
  }

  @override
  Future<void> requestOverlayPermission() => _call('requestOverlayPermission');

  @override
  Future<void> requestNotificationPermission() =>
      _call('requestNotificationPermission');

  @override
  Future<ScreenTimeAuthResult> requestScreenTimeAuthorization({
    ScreenTimeAuthMode mode = ScreenTimeAuthMode.child,
  }) async {
    final modeName = mode == ScreenTimeAuthMode.individual
        ? 'individual'
        : 'child';
    try {
      final map = await _channel.invokeMapMethod<String, Object?>(
        'requestScreenTimeAuthorization',
        {'mode': modeName},
      );
      if (map == null) {
        return ScreenTimeAuthResult(
          approved: false,
          mode: mode,
          errorCode: 'unavailable',
        );
      }
      return ScreenTimeAuthResult(
        approved: map['approved'] == true,
        mode: mode,
        errorCode: map['errorCode'] as String?,
      );
    } on MissingPluginException {
      return ScreenTimeAuthResult(
        approved: false,
        mode: mode,
        errorCode: 'unavailable',
      );
    }
  }

  @override
  Future<void> setRelaunchAfterLogin(bool allowed) =>
      _call('setRelaunchAfterLogin', {'allowed': allowed});

  @override
  Future<bool> chooseLimitedApps() async =>
      await _call<bool>('chooseLimitedApps') ?? false;

  @override
  Future<void> openBatteryOptimizationSettings() =>
      _call('openBatteryOptimizationSettings');

  @override
  Future<bool> openAutoStartSettings() async =>
      await _call<bool>('openAutoStartSettings') ?? false;

  @override
  Future<bool> openBackgroundPopupSettings() async =>
      await _call<bool>('openBackgroundPopupSettings') ?? false;

  @override
  Future<void> openAppSettings() => _call('openAppSettings');

  @override
  Future<void> openAccessibilitySettings() =>
      _call('openAccessibilitySettings');

  @override
  Future<bool> clearDeviceOwner() async =>
      await _call<bool>('clearDeviceOwner') ?? false;
}
