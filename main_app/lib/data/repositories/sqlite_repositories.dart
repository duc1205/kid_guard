import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../domain/entities/child_profile.dart';
import '../../domain/entities/usage_log.dart';
import '../../domain/entities/usage_stats.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/app_database.dart';

int _ms(DateTime d) => d.millisecondsSinceEpoch;
DateTime _dt(Object? v) => DateTime.fromMillisecondsSinceEpoch(v as int);
DateTime? _dtOrNull(Object? v) => v == null ? null : _dt(v);

class SqliteChildRepository implements ChildRepository {
  SqliteChildRepository(this._database);
  final AppDatabase _database;

  @override
  Future<List<ChildProfile>> getChildren() async {
    final rows = await _database.db.query('children', orderBy: 'name');
    return [
      for (final r in rows)
        ChildProfile(
          id: r['id'] as String,
          name: r['name'] as String,
          dateOfBirth: _dt(r['dob']),
          grade: r['grade'] as int,
          createdAt: _dt(r['created_at']),
        ),
    ];
  }

  /// Cập nhật trước, chưa có thì mới thêm. Không dựa vào giá trị trả về của
  /// `INSERT OR IGNORE`: khi trùng khoá, Android trả -1 còn SQLite FFI trả 0.
  /// Không dùng REPLACE: REPLACE = DELETE + INSERT sẽ kích hoạt CASCADE xoá lịch sử.
  @override
  Future<void> saveChild(ChildProfile child) => _database.db.transaction((
    txn,
  ) async {
    final updated = await txn.update(
      'children',
      {'name': child.name, 'dob': _ms(child.dateOfBirth), 'grade': child.grade},
      where: 'id = ?',
      whereArgs: [child.id],
    );
    if (updated == 0) {
      await txn.insert('children', {
        'id': child.id,
        'name': child.name,
        'dob': _ms(child.dateOfBirth),
        'grade': child.grade,
        'created_at': _ms(child.createdAt),
      });
    }
  });
}

class SqliteUsageLogRepository implements UsageLogRepository {
  SqliteUsageLogRepository(this._database);
  final AppDatabase _database;

  Database get _db => _database.db;

  @override
  Future<void> createLog(UsageLog log) => _db.insert('sessions', {
    'id': log.id,
    'child_id': log.childId,
    'child_name': log.childName,
    'grade': log.grade,
    'started_at': _ms(log.startedAt),
    'ended_at': log.endedAt == null ? null : _ms(log.endedAt!),
    'locked_at': log.lockedAt == null ? null : _ms(log.lockedAt!),
    'used_seconds': log.usedTime.inSeconds,
  });

  @override
  Future<void> addUsedTime(String logId, Duration duration) => _db.rawUpdate(
    'UPDATE sessions SET used_seconds = used_seconds + ? WHERE id = ?',
    [duration.inSeconds, logId],
  );

  @override
  Future<void> addAttempt(
    String logId,
    String childId,
    QuestionAttempt a,
  ) async {
    // Khôi phục thứ tự đáp án gốc để lưu snapshot dùng chung cho mọi lượt hỏi.
    final canonical = List<String>.filled(a.options.length, '');
    for (var i = 0; i < a.options.length; i++) {
      canonical[a.optionOrder[i]] = a.options[i];
    }
    await _db.transaction((txn) async {
      await txn.insert('question_snapshots', {
        'id': a.questionId,
        'subject': a.subject,
        'topic': a.topic,
        'text': a.questionText,
        'options': jsonEncode(canonical),
        'suggestion': a.suggestion,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      await txn.insert('attempts', {
        'session_id': logId,
        'child_id': childId,
        'question_id': a.questionId,
        'option_order': a.optionOrder.join(','),
        'chosen_index': a.chosenIndex,
        'correct_index': a.correctIndex,
        'is_correct': a.isCorrect ? 1 : 0,
        'answered_at': _ms(a.answeredAt),
      });
    });
  }

  @override
  Future<void> markLocked(String logId, DateTime at) => _db.update(
    'sessions',
    {'locked_at': _ms(at)},
    where: 'id = ? AND locked_at IS NULL',
    whereArgs: [logId],
  );

  @override
  Future<void> markEnded(String logId, DateTime at) => _db.update(
    'sessions',
    {'ended_at': _ms(at)},
    where: 'id = ?',
    whereArgs: [logId],
  );

  @override
  Future<List<String>> recentQuestionIds(
    String childId, {
    required int limit,
  }) async {
    final rows = await _db.query(
      'attempts',
      columns: ['question_id'],
      where: 'child_id = ?',
      whereArgs: [childId],
      orderBy: 'answered_at DESC',
      limit: limit,
    );
    return [for (final r in rows) r['question_id'] as String];
  }

  @override
  Future<List<ChildUsageStats>> getUsageStats() async {
    final rows = await _db.rawQuery('''
      SELECT s.child_id,
             SUM(s.used_seconds)  AS used,
             COUNT(*)             AS sessions,
             MAX(s.started_at)    AS last_used,
             COALESCE(a.correct, 0) AS correct,
             COALESCE(a.total, 0)   AS total
      FROM sessions s
      LEFT JOIN (
        SELECT child_id, SUM(is_correct) AS correct, COUNT(*) AS total
        FROM attempts GROUP BY child_id
      ) a ON a.child_id = s.child_id
      GROUP BY s.child_id''');
    return [
      for (final r in rows)
        ChildUsageStats(
          childId: r['child_id'] as String,
          totalUsed: Duration(seconds: (r['used'] as int?) ?? 0),
          sessionCount: r['sessions'] as int,
          correct: r['correct'] as int,
          wrong: (r['total'] as int) - (r['correct'] as int),
          lastUsedAt: _dtOrNull(r['last_used']),
        ),
    ];
  }

  @override
  Future<List<UsageLog>> getLogsForChild(
    String childId, {
    required int limit,
    int offset = 0,
  }) async {
    final sessions = await _db.query(
      'sessions',
      where: 'child_id = ?',
      whereArgs: [childId],
      orderBy: 'started_at DESC',
      limit: limit,
      offset: offset,
    );
    if (sessions.isEmpty) return const [];

    final ids = [for (final s in sessions) s['id'] as String];
    final placeholders = List.filled(ids.length, '?').join(',');
    final attemptRows = await _db.rawQuery('''
      SELECT a.*, q.subject, q.topic, q.text, q.options, q.suggestion
      FROM attempts a JOIN question_snapshots q ON q.id = a.question_id
      WHERE a.session_id IN ($placeholders)
      ORDER BY a.answered_at''', ids);

    final bySession = <String, List<QuestionAttempt>>{};
    for (final r in attemptRows) {
      final canonical = List<String>.from(jsonDecode(r['options'] as String));
      final order = (r['option_order'] as String)
          .split(',')
          .map(int.parse)
          .toList(growable: false);
      bySession
          .putIfAbsent(r['session_id'] as String, () => [])
          .add(
            QuestionAttempt(
              questionId: r['question_id'] as String,
              subject: r['subject'] as String,
              topic: r['topic'] as String,
              questionText: r['text'] as String,
              options: [for (final i in order) canonical[i]],
              optionOrder: order,
              correctIndex: r['correct_index'] as int,
              chosenIndex: r['chosen_index'] as int,
              suggestion: r['suggestion'] as String,
              answeredAt: _dt(r['answered_at']),
            ),
          );
    }

    return [
      for (final s in sessions)
        UsageLog(
          id: s['id'] as String,
          childId: s['child_id'] as String,
          childName: s['child_name'] as String,
          grade: s['grade'] as int,
          startedAt: _dt(s['started_at']),
          endedAt: _dtOrNull(s['ended_at']),
          lockedAt: _dtOrNull(s['locked_at']),
          usedTime: Duration(seconds: s['used_seconds'] as int),
          attempts: bySession[s['id']] ?? const [],
        ),
    ];
  }

  @override
  Future<List<WeakTopic>> getWeakTopics(
    String childId, {
    required int limit,
  }) async {
    final rows = await _db.rawQuery(
      '''
      SELECT q.subject, q.topic, COUNT(*) AS wrong
      FROM attempts a JOIN question_snapshots q ON q.id = a.question_id
      WHERE a.child_id = ? AND a.is_correct = 0
      GROUP BY q.subject, q.topic
      ORDER BY wrong DESC
      LIMIT ?''',
      [childId, limit],
    );
    return [
      for (final r in rows)
        WeakTopic(
          subject: r['subject'] as String,
          topic: r['topic'] as String,
          wrongCount: r['wrong'] as int,
        ),
    ];
  }

  @override
  Future<int> deleteEndedBefore(DateTime cutoff) =>
      _db.transaction((txn) async {
        final deleted = await txn.delete(
          'sessions',
          where: 'ended_at IS NOT NULL AND started_at < ?',
          whereArgs: [_ms(cutoff)],
        );
        if (deleted > 0) {
          // Dọn các câu hỏi không còn lượt trả lời nào tham chiếu.
          await txn.rawDelete('''
            DELETE FROM question_snapshots
            WHERE id NOT IN (SELECT DISTINCT question_id FROM attempts)''');
        }
        return deleted;
      });
}
