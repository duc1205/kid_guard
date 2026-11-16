import 'dart:math';

import '../../core/utils/clock.dart';
import '../repositories/repositories.dart';

enum PinError { length, digitsOnly, tooSimple }

class PinValidationException implements Exception {
  const PinValidationException(this.error);
  final PinError error;
  @override
  String toString() => 'PinValidationException($error)';
}

/// Quy tắc mã PIN phụ huynh: 4–8 chữ số, không quá dễ đoán.
class PinPolicy {
  PinPolicy._();

  static const minLength = 4;
  static const maxLength = 8;

  /// Sai bấy nhiêu lần liên tiếp thì bắt đầu khoá tạm.
  static const freeAttempts = 5;
  static const firstLockout = Duration(seconds: 30);
  static const maxLockout = Duration(minutes: 15);

  static PinError? validate(String pin) {
    if (pin.length < minLength || pin.length > maxLength) {
      return PinError.length;
    }
    if (!RegExp(r'^\d+$').hasMatch(pin)) return PinError.digitsOnly;
    final digits = pin.codeUnits;
    final allSame = digits.every((c) => c == digits.first);
    var up = true, down = true;
    for (var i = 1; i < digits.length; i++) {
      if (digits[i] != digits[i - 1] + 1) up = false;
      if (digits[i] != digits[i - 1] - 1) down = false;
    }
    return allSame || up || down ? PinError.tooSimple : null;
  }

  /// Thời gian khoá sau lần sai thứ [failed]: 30 giây, gấp đôi mỗi lần, tối đa 15 phút.
  static Duration? lockoutAfter(int failed) {
    if (failed < freeAttempts) return null;
    final factor = 1 << min(failed - freeAttempts, 10);
    final d = firstLockout * factor;
    return d > maxLockout ? maxLockout : d;
  }
}

class SetParentPinUseCase {
  SetParentPinUseCase(this._pins);
  final ParentPinRepository _pins;

  /// Ném [PinValidationException] nếu mã không hợp lệ.
  Future<void> call(String pin) async {
    final error = PinPolicy.validate(pin);
    if (error != null) throw PinValidationException(error);
    await _pins.setPin(pin);
    await _pins.setAttempts(const PinAttempts());
  }
}

sealed class PinCheckResult {
  const PinCheckResult();
}

class PinOk extends PinCheckResult {
  const PinOk();
}

class PinWrong extends PinCheckResult {
  const PinWrong({required this.attemptsLeft, this.lockedFor});

  /// Số lần còn được thử trước khi bị khoá tạm (0 nếu đang bị khoá).
  final int attemptsLeft;
  final Duration? lockedFor;
}

class PinLockedOut extends PinCheckResult {
  const PinLockedOut(this.remaining);
  final Duration remaining;
}

/// Kiểm tra mã PIN, đếm số lần sai và khoá tạm để bé không đoán dần được.
class VerifyParentPinUseCase {
  VerifyParentPinUseCase(this._pins, {Clock clock = systemClock})
    : _clock = clock;

  final ParentPinRepository _pins;
  final Clock _clock;

  /// Còn bị khoá bao lâu (null nếu được thử).
  Future<Duration?> lockedFor() async {
    final until = (await _pins.getAttempts()).lockedUntil;
    final now = _clock();
    return until != null && now.isBefore(until) ? until.difference(now) : null;
  }

  Future<PinCheckResult> call(String pin) async {
    final locked = await lockedFor();
    if (locked != null) return PinLockedOut(locked);
    if (await _pins.checkPin(pin)) {
      await _pins.setAttempts(const PinAttempts());
      return const PinOk();
    }
    final failed = (await _pins.getAttempts()).failed + 1;
    final lockout = PinPolicy.lockoutAfter(failed);
    await _pins.setAttempts(
      PinAttempts(
        failed: failed,
        lockedUntil: lockout == null ? null : _clock().add(lockout),
      ),
    );
    return PinWrong(
      attemptsLeft: max(0, PinPolicy.freeAttempts - failed),
      lockedFor: lockout,
    );
  }
}
