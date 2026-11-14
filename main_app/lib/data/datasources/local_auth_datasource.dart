import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

import '../../domain/repositories/repositories.dart';

/// Xác thực bằng khoá màn hình của máy (mã PIN / mật khẩu / hình vẽ, hoặc
/// sinh trắc học đã đăng ký trên máy). `biometricOnly: false` để luôn có thể
/// nhập mật khẩu máy.
class LocalAuthDataSource implements ParentAuthRepository {
  LocalAuthDataSource({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      debugPrint('local_auth isDeviceSupported error: $e');
      return false;
    }
  }

  @override
  Future<ParentAuthResult> authenticate(String reason) async {
    if (!await isAvailable()) return ParentAuthResult.notAvailable;
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      return ok ? ParentAuthResult.success : ParentAuthResult.failed;
    } on LocalAuthException catch (e) {
      debugPrint('local_auth error: ${e.code} ${e.description}');
      if (e.code == LocalAuthExceptionCode.noCredentialsSet) {
        return ParentAuthResult.notAvailable;
      }
      return ParentAuthResult.failed;
    }
  }
}
