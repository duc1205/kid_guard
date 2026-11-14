import 'package:flutter/services.dart';

/// Ngân hàng câu hỏi đóng gói sẵn trong app (chạy offline):
/// assets/questions/grade_N.json + manifest.json. Dùng khi chưa tải được bản
/// mới từ internet.
class QuestionAssetDataSource {
  QuestionAssetDataSource({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  Future<String> loadGrade(int grade) =>
      _bundle.loadString('assets/questions/grade_$grade.json', cache: false);

  Future<String> loadManifest() =>
      _bundle.loadString('assets/questions/manifest.json', cache: false);
}
