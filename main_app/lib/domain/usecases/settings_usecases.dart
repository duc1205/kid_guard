import '../../core/constants/app_constants.dart';
import '../repositories/repositories.dart';

class InitialAllowanceTooShortException implements Exception {
  const InitialAllowanceTooShortException();
  @override
  String toString() => 'InitialAllowanceTooShortException';
}

/// Người lớn đặt thời gian dùng ban đầu: tối thiểu 5 phút, không giới hạn tối đa.
/// `null` = quay về mặc định 15 phút.
class SetInitialAllowanceUseCase {
  SetInitialAllowanceUseCase(this._settings);
  final SettingsRepository _settings;

  Future<void> call(Duration? value) async {
    if (value != null && value < AppConstants.minInitialAllowance) {
      throw const InitialAllowanceTooShortException();
    }
    await _settings.setInitialAllowance(value);
  }
}
