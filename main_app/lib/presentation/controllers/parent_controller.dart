import 'package:flutter/foundation.dart';

import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/parent_usecases.dart';

class ParentController extends ChangeNotifier {
  ParentController({
    required GetChildReportsUseCase getReports,
    required AuthenticateParentUseCase authenticateParent,
  }) : _getReports = getReports,
       _authenticateParent = authenticateParent;

  final GetChildReportsUseCase _getReports;
  final AuthenticateParentUseCase _authenticateParent;

  bool loading = false;
  List<ChildReport> reports = const [];

  /// [reason] là câu hiển thị trên hộp thoại xác thực của hệ thống (đã dịch).
  Future<ParentAuthResult> authenticate({required String reason}) =>
      _authenticateParent(reason);

  Future<void> load() async {
    loading = true;
    notifyListeners();
    reports = await _getReports();
    loading = false;
    notifyListeners();
  }
}
