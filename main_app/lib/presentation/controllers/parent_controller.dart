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
    required RegisterChildUseCase registerChild,
    required DeleteChildUseCase deleteChild,
    required ClearAllChildrenDataUseCase clearAllChildrenData,
  }) : _getReports = getReports,
       _authenticateParent = authenticateParent,
       _updateChild = updateChild,
       _registerChild = registerChild,
       _deleteChild = deleteChild,
       _clearAllChildrenData = clearAllChildrenData;

  final GetChildReportsUseCase _getReports;
  final AuthenticateParentUseCase _authenticateParent;
  final UpdateChildUseCase _updateChild;
  final RegisterChildUseCase _registerChild;
  final DeleteChildUseCase _deleteChild;
  final ClearAllChildrenDataUseCase _clearAllChildrenData;

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

  /// Bố mẹ thêm hồ sơ bé trước (để đặt việc học) — bé chưa cần dùng máy.
  /// Trùng tên + ngày sinh với bé đã có → dùng lại hồ sơ đó.
  /// Ném [ValidationException] nếu sai.
  Future<ChildProfile> addChild({
    required String name,
    required DateTime? dateOfBirth,
    required int? grade,
  }) async {
    final child = await _registerChild(
      name: name,
      dateOfBirth: dateOfBirth,
      grade: grade,
    );
    await load();
    return child;
  }

  /// Ném [ActiveSessionExistsException] nếu còn phiên đang chạy.
  Future<void> deleteChild(String childId) async {
    await _deleteChild(childId);
    await load();
  }

  /// Ném [ActiveSessionExistsException] nếu còn phiên đang chạy.
  Future<void> clearAllChildrenData() async {
    await _clearAllChildrenData();
    await load();
  }

  Future<void> load() async {
    loading = true;
    notifyListeners();
    reports = await _getReports();
    loading = false;
    notifyListeners();
  }
}
