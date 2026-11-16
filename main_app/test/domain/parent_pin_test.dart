import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:main_app/data/repositories/parent_pin_repository.dart';
import 'package:main_app/domain/usecases/parent_pin_usecases.dart';

import '../fakes.dart';

void main() {
  test('quy tắc mã PIN: 4–8 chữ số, không quá dễ đoán', () {
    expect(PinPolicy.validate('123'), PinError.length);
    expect(PinPolicy.validate('123456789'), PinError.length);
    expect(PinPolicy.validate('12a4'), PinError.digitsOnly);
    expect(PinPolicy.validate('1111'), PinError.tooSimple);
    expect(PinPolicy.validate('1234'), PinError.tooSimple);
    expect(PinPolicy.validate('9876'), PinError.tooSimple);
    expect(PinPolicy.validate('2580'), isNull);
    expect(PinPolicy.validate('19072018'), isNull);
  });

  test('PBKDF2-HMAC-SHA256 khớp vector chuẩn', () {
    String h(int c) => pbkdf2(
      utf8.encode('password'),
      utf8.encode('salt'),
      c,
    ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    expect(
      h(1),
      '120fb6cffcf8b32c43e7225256c4f837a86548c92ccc35480805987cb70be17b',
    );
    expect(
      h(2),
      'ae4d0c95af6b46d32d0adff928f06dd02a303f8ef3c251dfd6e2d85a95474c43',
    );
  });

  test('chỉ lưu bản băm có salt, không lưu mã gốc', () async {
    final store = MemoryLocalStore();
    final repo = PrefsParentPinRepository(store, iterations: 10);
    expect(await repo.hasPin(), isFalse);
    await SetParentPinUseCase(repo)('2580');
    expect(await repo.hasPin(), isTrue);
    expect(jsonEncode(store.values), isNot(contains('2580')));
    expect(await repo.checkPin('2580'), isTrue);
    expect(await repo.checkPin('2581'), isFalse);
    expect(
      () => SetParentPinUseCase(repo)('0000'),
      throwsA(isA<PinValidationException>()),
    );
    // Cùng mã, salt khác → bản băm khác.
    final other = MemoryLocalStore();
    await PrefsParentPinRepository(other, iterations: 10).setPin('2580');
    expect(
      (other.values['kg.parent_pin'] as Map)['hash'],
      isNot((store.values['kg.parent_pin'] as Map)['hash']),
    );
  });

  test(
    'sai 5 lần → khoá 30 giây, sai tiếp → gấp đôi; đúng → xoá đếm',
    () async {
      final clock = FakeClock(DateTime(2026, 11, 16, 20));
      final repo = PrefsParentPinRepository(MemoryLocalStore(), iterations: 10);
      await repo.setPin('2580');
      final verify = VerifyParentPinUseCase(repo, clock: clock.call);

      for (var i = 1; i <= 4; i++) {
        final r = await verify('0000') as PinWrong;
        expect(r.attemptsLeft, 5 - i);
        expect(r.lockedFor, isNull);
      }
      final fifth = await verify('0000') as PinWrong;
      expect(fifth.lockedFor, const Duration(seconds: 30));

      // Đang khoá: kể cả mã đúng cũng chưa được thử.
      expect(await verify('2580'), isA<PinLockedOut>());

      clock.advance(const Duration(seconds: 31));
      final sixth = await verify('0000') as PinWrong;
      expect(sixth.lockedFor, const Duration(minutes: 1));

      clock.advance(const Duration(minutes: 2));
      expect(await verify('2580'), isA<PinOk>());
      expect(await verify.lockedFor(), isNull);
      expect((await verify('0000') as PinWrong).attemptsLeft, 4);
    },
  );

  test('thời gian khoá tối đa 15 phút', () {
    expect(PinPolicy.lockoutAfter(4), isNull);
    expect(PinPolicy.lockoutAfter(30), const Duration(minutes: 15));
  });
}
