// Sinh assets/questions/manifest.json từ các file grade_N.json.
//
//   fvm dart run tool/make_question_manifest.dart
//
// Tự tăng `version` khi có file thay đổi (so mã sha256 với manifest cũ).
// Chạy lại mỗi khi sửa câu hỏi, rồi đẩy cả thư mục assets/questions/ lên repo
// câu hỏi công khai (xem README › Nguồn câu hỏi).
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

void main() {
  final dir = Directory('assets/questions');
  final manifestFile = File('${dir.path}/manifest.json');
  final old = manifestFile.existsSync()
      ? jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>
      : <String, dynamic>{};
  final oldGrades = (old['grades'] as Map<String, dynamic>?) ?? {};

  final pattern = RegExp(r'^grade_(\d+)\.json$');
  final files =
      dir
          .listSync()
          .whereType<File>()
          .map((f) => (f, pattern.firstMatch(f.uri.pathSegments.last)))
          .where((e) => e.$2 != null)
          .toList()
        ..sort(
          (a, b) =>
              int.parse(a.$2!.group(1)!).compareTo(int.parse(b.$2!.group(1)!)),
        );

  var changed = old.isEmpty;
  final grades = <String, dynamic>{};
  for (final (file, match) in files) {
    final grade = match!.group(1)!;
    final bytes = file.readAsBytesSync();
    final sha = sha256.convert(bytes).toString();
    final count = (jsonDecode(utf8.decode(bytes)) as List).length;
    grades[grade] = {
      'file': file.uri.pathSegments.last,
      'sha256': sha,
      'count': count,
    };
    if ((oldGrades[grade] as Map?)?['sha256'] != sha) changed = true;
  }
  if (oldGrades.keys.toSet().difference(grades.keys.toSet()).isNotEmpty) {
    changed = true;
  }

  final oldVersion = (old['version'] as int?) ?? 0;
  final version = changed ? oldVersion + 1 : oldVersion;
  final manifest = {
    'version': version,
    'updatedAt': changed
        ? DateTime.now().toUtc().toIso8601String().substring(0, 10)
        : old['updatedAt'],
    'grades': grades,
  };
  manifestFile.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(manifest)}\n',
  );
  stdout.writeln(
    changed
        ? 'manifest.json → version $version (${grades.length} files)'
        : 'manifest.json unchanged (version $version)',
  );
}
