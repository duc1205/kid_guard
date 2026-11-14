import '../../core/constants/app_constants.dart';
import '../../core/utils/clock.dart';
import '../entities/child_profile.dart';
import '../repositories/repositories.dart';

/// Lỗi dữ liệu nhập — domain chỉ trả mã lỗi, tầng giao diện tự dịch theo ngôn ngữ máy.
enum ValidationError { nameRequired, dobRequired, dobInvalid, gradeRequired }

class ValidationException implements Exception {
  const ValidationException(this.error);
  final ValidationError error;
  @override
  String toString() => 'ValidationException($error)';
}

/// Chuẩn hoá & kiểm tra thông tin trẻ. Trả về (tên đã chuẩn hoá, ngày sinh không giờ, lớp).
(String, DateTime, int) _validate({
  required String name,
  required DateTime? dateOfBirth,
  required int? grade,
  required DateTime now,
}) {
  final trimmed = name.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (trimmed.length < 2) {
    throw const ValidationException(ValidationError.nameRequired);
  }
  if (dateOfBirth == null) {
    throw const ValidationException(ValidationError.dobRequired);
  }
  if (!dateOfBirth.isBefore(now)) {
    throw const ValidationException(ValidationError.dobInvalid);
  }
  if (grade == null ||
      grade < AppConstants.minGrade ||
      grade > AppConstants.maxGrade) {
    throw const ValidationException(ValidationError.gradeRequired);
  }
  return (
    trimmed,
    DateTime(dateOfBirth.year, dateOfBirth.month, dateOfBirth.day),
    grade,
  );
}

/// Trẻ nhập tên, ngày sinh, lớp. Nếu trùng tên + ngày sinh với hồ sơ cũ thì
/// dùng lại hồ sơ đó (cập nhật lớp) để log của trẻ được gom chung.
class RegisterChildUseCase {
  RegisterChildUseCase(this._children, this._newId, {Clock clock = systemClock})
    : _clock = clock;

  final ChildRepository _children;
  final String Function() _newId;
  final Clock _clock;

  Future<ChildProfile> call({
    required String name,
    required DateTime? dateOfBirth,
    required int? grade,
  }) async {
    final now = _clock();
    final (trimmed, dob, validGrade) = _validate(
      name: name,
      dateOfBirth: dateOfBirth,
      grade: grade,
      now: now,
    );
    final existing = (await _children.getChildren()).where(
      (c) =>
          c.name.toLowerCase() == trimmed.toLowerCase() && c.dateOfBirth == dob,
    );

    final child = existing.isNotEmpty
        ? existing.first.copyWith(name: trimmed, grade: validGrade)
        : ChildProfile(
            id: _newId(),
            name: trimmed,
            dateOfBirth: dob,
            grade: validGrade,
            createdAt: now,
          );
    await _children.saveChild(child);
    return child;
  }
}

/// Người lớn sửa thông tin trẻ đã lưu (vd. lên lớp mỗi năm để câu hỏi đúng
/// trình độ). Giữ nguyên id nên lịch sử cũ vẫn gắn với trẻ.
class UpdateChildUseCase {
  UpdateChildUseCase(this._children, {Clock clock = systemClock})
    : _clock = clock;

  final ChildRepository _children;
  final Clock _clock;

  Future<ChildProfile> call(
    ChildProfile child, {
    required String name,
    required DateTime? dateOfBirth,
    required int? grade,
  }) async {
    final (trimmed, dob, validGrade) = _validate(
      name: name,
      dateOfBirth: dateOfBirth,
      grade: grade,
      now: _clock(),
    );
    final updated = child.copyWith(
      name: trimmed,
      dateOfBirth: dob,
      grade: validGrade,
    );
    await _children.saveChild(updated);
    return updated;
  }
}
