import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_database.dart';

class CachedQuestionFile {
  const CachedQuestionFile({required this.sha256, required this.json});
  final String sha256;
  final String json;
}

/// Câu hỏi đã tải từ internet, lưu trong SQLite (bảng `question_bank`).
class QuestionCacheDataSource {
  QuestionCacheDataSource(this._database);
  final AppDatabase _database;

  Database get _db => _database.db;

  Future<CachedQuestionFile?> read(int grade) async {
    final rows = await _db.query(
      'question_bank',
      where: 'grade = ?',
      whereArgs: [grade],
    );
    if (rows.isEmpty) return null;
    return CachedQuestionFile(
      sha256: rows.first['sha256'] as String,
      json: rows.first['json'] as String,
    );
  }

  Future<Map<int, String>> hashes() async {
    final rows = await _db.query('question_bank', columns: ['grade', 'sha256']);
    return {for (final r in rows) r['grade'] as int: r['sha256'] as String};
  }

  /// Ghi tất cả trong 1 transaction: hoặc cập nhật đủ, hoặc giữ nguyên bản cũ.
  Future<void> writeAll(Map<int, CachedQuestionFile> files) =>
      _db.transaction((txn) async {
        for (final e in files.entries) {
          await txn.insert('question_bank', {
            'grade': e.key,
            'sha256': e.value.sha256,
            'json': e.value.json,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });

  Future<void> clear() => _db.delete('question_bank');
}
