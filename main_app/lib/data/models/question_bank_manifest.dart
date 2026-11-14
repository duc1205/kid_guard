import '../../core/constants/app_constants.dart';

/// manifest.json của ngân hàng câu hỏi:
/// ```json
/// {"version": 3, "grades": {"1": {"file": "grade_1.json", "sha256": "…", "count": 24}}}
/// ```
/// `file` tính tương đối so với địa chỉ của manifest.
class QuestionBankManifest {
  const QuestionBankManifest({required this.version, required this.grades});

  final int version;
  final Map<int, ManifestEntry> grades;

  /// Ném [FormatException] nếu sai định dạng.
  factory QuestionBankManifest.fromJson(Object? json) {
    if (json is! Map) throw const FormatException('manifest is not an object');
    final version = json['version'];
    final grades = json['grades'];
    if (version is! int || version < 1 || grades is! Map) {
      throw const FormatException('manifest missing version/grades');
    }
    final entries = <int, ManifestEntry>{};
    grades.forEach((key, value) {
      final grade = int.tryParse('$key');
      if (grade == null ||
          grade < AppConstants.minGrade ||
          grade > AppConstants.maxGrade) {
        return; // Bỏ qua lớp app không hỗ trợ (bản manifest mới hơn app).
      }
      if (value is! Map ||
          value['file'] is! String ||
          value['sha256'] is! String ||
          (value['file'] as String).isEmpty) {
        throw FormatException('manifest entry for grade $grade is invalid');
      }
      entries[grade] = ManifestEntry(
        file: value['file'] as String,
        sha256: (value['sha256'] as String).toLowerCase(),
      );
    });
    return QuestionBankManifest(version: version, grades: entries);
  }
}

class ManifestEntry {
  const ManifestEntry({required this.file, required this.sha256});
  final String file;
  final String sha256;
}
