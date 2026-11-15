import 'package:flutter_test/flutter_test.dart';
import 'package:main_app/data/repositories/repository_impls.dart';
import 'package:main_app/domain/repositories/repositories.dart';
import 'package:main_app/domain/usecases/advanced_lock_usecases.dart';

import '../fakes.dart';

/// Android tự tắt Trợ năng khi app bị buộc dừng → app phải phát hiện để báo phụ huynh.
void main() {
  late CheckAdvancedLockUseCase check;

  DevicePermissions perms({
    required bool accessibility,
    DevicePlatform platform = DevicePlatform.android,
  }) => DevicePermissions(
    platform: platform,
    overlay: true,
    notifications: true,
    deviceOwner: false,
    accessibility: accessibility,
    supported: true,
  );

  setUp(() {
    check = CheckAdvancedLockUseCase(
      PrefsAdvancedLockMemoryRepository(MemoryLocalStore()),
    );
  });

  test('chưa từng bật → off, không cảnh báo', () async {
    expect(await check(perms(accessibility: false)), AdvancedLockStatus.off);
  });

  test('đang bật → on', () async {
    expect(await check(perms(accessibility: true)), AdvancedLockStatus.on);
  });

  test('từng bật rồi bị hệ thống tắt → droppedBySystem', () async {
    await check(perms(accessibility: true));
    expect(
      await check(perms(accessibility: false)),
      AdvancedLockStatus.droppedBySystem,
    );
  });

  test('bật lại → on; phụ huynh chọn không dùng nữa → off', () async {
    await check(perms(accessibility: true));
    expect(await check(perms(accessibility: true)), AdvancedLockStatus.on);
    await check.forget();
    expect(await check(perms(accessibility: false)), AdvancedLockStatus.off);
  });

  test('không phải Android → luôn off', () async {
    expect(
      await check(perms(accessibility: true, platform: DevicePlatform.ios)),
      AdvancedLockStatus.off,
    );
  });
}
