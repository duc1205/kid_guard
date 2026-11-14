import 'package:flutter_test/flutter_test.dart';
import 'package:main_app/domain/repositories/repositories.dart';

void main() {
  test('nhận diện hãng từ Build.MANUFACTURER', () {
    expect(OemFamily.fromManufacturer('Xiaomi'), OemFamily.xiaomi);
    expect(OemFamily.fromManufacturer('OPPO'), OemFamily.oppo);
    expect(OemFamily.fromManufacturer('realme'), OemFamily.oppo);
    expect(OemFamily.fromManufacturer('OnePlus'), OemFamily.oppo);
    expect(OemFamily.fromManufacturer('vivo'), OemFamily.vivo);
    expect(OemFamily.fromManufacturer('samsung'), OemFamily.samsung);
    expect(OemFamily.fromManufacturer('HONOR'), OemFamily.huawei);
    expect(OemFamily.fromManufacturer('Google'), OemFamily.other);
  });

  test(
    'chỉ Xiaomi/Vivo có quyền bật lên khi chạy nền; Samsung không có Tự khởi động',
    () {
      expect(OemFamily.xiaomi.hasBackgroundPopupPermission, isTrue);
      expect(OemFamily.vivo.hasBackgroundPopupPermission, isTrue);
      expect(OemFamily.oppo.hasBackgroundPopupPermission, isFalse);
      expect(OemFamily.samsung.hasAutoStart, isFalse);
      expect(OemFamily.oppo.hasAutoStart, isTrue);
    },
  );
}
