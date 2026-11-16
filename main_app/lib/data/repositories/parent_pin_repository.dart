import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../../domain/repositories/repositories.dart';
import '../datasources/local_store.dart';

/// Mã PIN phụ huynh: chỉ lưu `v1$vòng lặp$salt$băm` (PBKDF2-HMAC-SHA256,
/// salt ngẫu nhiên 16 byte) trong bộ nhớ riêng của app — không lưu mã gốc.
class PrefsParentPinRepository implements ParentPinRepository {
  PrefsParentPinRepository(
    this._store, {
    this.iterations = 20000,
    Random? random,
  }) : _random = random ?? Random.secure();

  final LocalStore _store;
  final Random _random;

  /// Số vòng lặp cho mã mới (mã cũ dùng số vòng lưu kèm).
  final int iterations;

  static const _pinKey = 'kg.parent_pin';
  static const _failedKey = 'kg.parent_pin_failed';
  static const _lockedUntilKey = 'kg.parent_pin_locked_until';
  static const _deviceAuthKey = 'kg.parent_pin_device_auth';

  @override
  Future<bool> hasPin() async => (await _store.readObject(_pinKey)) != null;

  @override
  Future<void> setPin(String pin) async {
    final salt = Uint8List.fromList(
      List<int>.generate(16, (_) => _random.nextInt(256)),
    );
    await _store.writeObject(_pinKey, {
      'v': 1,
      'iterations': iterations,
      'salt': base64Encode(salt),
      'hash': base64Encode(await _hash(pin, salt, iterations)),
    });
  }

  @override
  Future<bool> checkPin(String pin) async {
    final j = await _store.readObject(_pinKey);
    if (j == null) return false;
    final expected = base64Decode(j['hash'] as String);
    final actual = await _hash(
      pin,
      base64Decode(j['salt'] as String),
      j['iterations'] as int,
    );
    // So sánh không dừng sớm.
    var diff = expected.length ^ actual.length;
    for (var i = 0; i < min(expected.length, actual.length); i++) {
      diff |= expected[i] ^ actual[i];
    }
    return diff == 0;
  }

  @override
  Future<PinAttempts> getAttempts() async {
    final until = await _store.readInt(_lockedUntilKey);
    return PinAttempts(
      failed: await _store.readInt(_failedKey) ?? 0,
      lockedUntil: until == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(until),
    );
  }

  @override
  Future<void> setAttempts(PinAttempts a) async {
    await _store.writeInt(_failedKey, a.failed);
    final until = a.lockedUntil;
    if (until == null) {
      await _store.remove(_lockedUntilKey);
    } else {
      await _store.writeInt(_lockedUntilKey, until.millisecondsSinceEpoch);
    }
  }

  @override
  Future<bool> deviceAuthAllowed() => _store.readBool(_deviceAuthKey);

  @override
  Future<void> setDeviceAuthAllowed(bool allowed) =>
      _store.writeBool(_deviceAuthKey, allowed);
}

/// Băm ở isolate riêng để không làm khựng giao diện (~0,3 giây).
Future<Uint8List> _hash(String pin, List<int> salt, int iterations) =>
    Isolate.run(() => pbkdf2(utf8.encode(pin), salt, iterations));

/// PBKDF2-HMAC-SHA256, 1 khối 32 byte (RFC 8018).
Uint8List pbkdf2(List<int> password, List<int> salt, int iterations) {
  final hmac = Hmac(sha256, password);
  var u = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
  final out = Uint8List.fromList(u);
  for (var i = 1; i < iterations; i++) {
    u = hmac.convert(u).bytes;
    for (var j = 0; j < out.length; j++) {
      out[j] ^= u[j];
    }
  }
  return out;
}
