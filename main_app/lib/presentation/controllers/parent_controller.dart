import 'package:flutter/foundation.dart';

import '../../domain/entities/child_profile.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/parent_usecases.dart';
import '../../domain/usecases/register_child.dart';

class ParentController extends ChangeNotifier {
  ParentController({
    required GetChildReportsUseCase getReports,
    required AuthenticateParentUseCase authenticateParent,
    required UpdateChildUseCase updateChild,
  }) : _getReports = getReports,
       _authenticateParent = authenticateParent,
       _updateChild = updateChild;

  final GetChildReportsUseCase _getReports;
  final AuthenticateParentUseCase _authenticateParent;
  final UpdateChildUseCase _updateChild;

  bool loading = false;
  List<ChildReport> reports = const [];

  /// [reason] là câu hiển thị trên hộp thoại xác thực của hệ thống (đã dịch).
  Future<ParentAuthResult> authenticate({required String reason}) =>
      _authenticateParent(reason);

  /// Sửa thông tin bé rồi tải lại danh sách. Ném [ValidationException] nếu sai.
  Future<ChildProfile> updateChild(
    ChildProfile child, {
    required String name,
    required DateTime? dateOfBirth,
    required int? grade,
  }) async {
    final updated = await _updateChild(
      child,
      name: name,
      dateOfBirth: dateOfBirth,
      grade: grade,
    );
    await load();
    return updated;
  }

  Future<void> load() async {
    loading = true;
    notifyListeners();
    reports = await _getReports();
    loading = false;
    notifyListeners();
  }
}
