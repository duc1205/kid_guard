import 'package:flutter/foundation.dart';

import '../../domain/repositories/repositories.dart';
import '../models/json_mappers.dart';
import 'local_store.dart';

/// Chuyển dữ liệu từ bản cũ (JSON trong SharedPreferences) sang SQLite, chạy một lần.
class LegacyPrefsMigration {
  LegacyPrefsMigration(this._store, this._children, this._logs);

  final LocalStore _store;
  final ChildRepository _children;
  final UsageLogRepository _logs;

  Future<void> run() async {
    try {
      final children = await _store.readList(LocalStore.legacyChildrenKey);
      final logs = await _store.readList(LocalStore.legacyLogsKey);
      if (children.isEmpty && logs.isEmpty) return;

      for (final j in children) {
        await _children.saveChild(ChildProfileMapper.fromJson(j));
      }
      for (final j in logs) {
        final log = UsageLogMapper.fromJson(j);
        await _logs.createLog(log.copyWith(attempts: const []));
        for (final a in log.attempts) {
          await _logs.addAttempt(log.id, log.childId, a);
        }
      }
      await _store.remove(LocalStore.legacyChildrenKey);
      await _store.remove(LocalStore.legacyLogsKey);
      debugPrint(
        'Migrated ${children.length} children, ${logs.length} logs to SQLite',
      );
    } catch (e) {
      // Không chặn app nếu dữ liệu cũ hỏng; giữ nguyên để thử lại lần sau.
      debugPrint('Legacy migration failed: $e');
    }
  }
}
