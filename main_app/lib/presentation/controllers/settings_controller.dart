import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/settings_usecases.dart';

/// Cài đặt của người lớn, dùng chung cho màn trẻ (hiển thị) và khu phụ huynh (sửa).
class SettingsController extends ChangeNotifier {
  SettingsController({
    required SettingsRepository settings,
    required SetInitialAllowanceUseCase setInitialAllowance,
  }) : _settings = settings,
       _setInitialAllowance = setInitialAllowance;

  final SettingsRepository _settings;
  final SetInitialAllowanceUseCase _setInitialAllowance;

  Duration initialAllowance = AppConstants.defaultInitialAllowance;

  bool get isDefault =>
      initialAllowance == AppConstants.defaultInitialAllowance;

  Future<void> load() async {
    initialAllowance = await _settings.getInitialAllowance();
    notifyListeners();
  }

  /// Ném [InitialAllowanceTooShortException] nếu dưới 5 phút. `null` = mặc định.
  Future<void> setInitialAllowance(Duration? value) async {
    await _setInitialAllowance(value);
    await load();
  }
}
