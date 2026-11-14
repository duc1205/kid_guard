import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// CSDL SQLite cục bộ, nằm trong thư mục dữ liệu riêng của app
/// (Android: /data/data/com.pham.kidguard/databases/kidguard.db) —
/// không làm tăng dung lượng APK, bị xoá khi gỡ app.
///
/// Thiết kế để nhỏ gọn & nhanh:
/// - Thời gian lưu dạng số nguyên (epoch ms) thay vì chuỗi ISO.
/// - Nội dung câu hỏi lưu MỘT lần trong `question_snapshots`; mỗi lượt trả lời
///   chỉ lưu id câu hỏi + thứ tự đáp án + lựa chọn (~40 byte thay vì ~570 byte JSON).
/// - Index theo (child_id, thời gian) cho các truy vấn thống kê / phân trang.
/// - Xoá phiên → các lượt trả lời bị xoá theo (ON DELETE CASCADE).
/// - `question_bank`: câu hỏi tải từ internet để dùng khi mất mạng (v2).
class AppDatabase {
  AppDatabase._(this.db);

  final Database db;

  static const _version = 2;

  static Future<AppDatabase> open({
    DatabaseFactory? factory,
    String? path,
  }) async {
    final f = factory ?? _defaultFactory();
    final dbPath = path ?? p.join(await f.getDatabasesPath(), 'kidguard.db');
    final db = await f.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: _version,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          await _createV1(db);
          await _createV2(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) await _createV2(db);
        },
      ),
    );
    return AppDatabase._(db);
  }

  /// Android/iOS/macOS: plugin sqflite gốc. Windows/Linux: SQLite qua FFI.
  static DatabaseFactory _defaultFactory() {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      return databaseFactoryFfi;
    }
    return databaseFactory;
  }

  static Future<void> _createV1(Database db) async {
    final batch = db.batch()
      ..execute('''
        CREATE TABLE children (
          id          TEXT PRIMARY KEY,
          name        TEXT NOT NULL,
          dob         INTEGER NOT NULL,
          grade       INTEGER NOT NULL,
          created_at  INTEGER NOT NULL
        )''')
      ..execute('''
        CREATE TABLE sessions (
          id            TEXT PRIMARY KEY,
          child_id      TEXT NOT NULL REFERENCES children(id) ON DELETE CASCADE,
          child_name    TEXT NOT NULL,
          grade         INTEGER NOT NULL,
          started_at    INTEGER NOT NULL,
          ended_at      INTEGER,
          locked_at     INTEGER,
          used_seconds  INTEGER NOT NULL DEFAULT 0
        )''')
      ..execute(
        'CREATE INDEX idx_sessions_child_time ON sessions(child_id, started_at DESC)',
      )
      ..execute('''
        CREATE TABLE question_snapshots (
          id          TEXT PRIMARY KEY,
          subject     TEXT NOT NULL,
          topic       TEXT NOT NULL,
          text        TEXT NOT NULL,
          options     TEXT NOT NULL,
          suggestion  TEXT NOT NULL
        )''')
      ..execute('''
        CREATE TABLE attempts (
          id            INTEGER PRIMARY KEY AUTOINCREMENT,
          session_id    TEXT NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
          child_id      TEXT NOT NULL,
          question_id   TEXT NOT NULL REFERENCES question_snapshots(id),
          option_order  TEXT NOT NULL,
          chosen_index  INTEGER NOT NULL,
          correct_index INTEGER NOT NULL,
          is_correct    INTEGER NOT NULL,
          answered_at   INTEGER NOT NULL
        )''')
      ..execute(
        'CREATE INDEX idx_attempts_child_time ON attempts(child_id, answered_at DESC)',
      )
      ..execute('CREATE INDEX idx_attempts_session ON attempts(session_id)')
      ..execute('CREATE INDEX idx_attempts_question ON attempts(question_id)');
    await batch.commit(noResult: true);
  }

  /// v2: câu hỏi tải từ internet (mỗi lớp 1 dòng, JSON nguyên file + mã kiểm tra).
  static Future<void> _createV2(Database db) => db.execute('''
    CREATE TABLE question_bank (
      grade   INTEGER PRIMARY KEY,
      sha256  TEXT NOT NULL,
      json    TEXT NOT NULL
    )''');

  Future<void> close() => db.close();
}
