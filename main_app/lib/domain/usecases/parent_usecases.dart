import '../../core/constants/app_constants.dart';
import '../entities/child_profile.dart';
import '../entities/usage_log.dart';
import '../entities/usage_stats.dart';
import '../repositories/repositories.dart';

/// Xác thực người lớn bằng mật khẩu máy. Trong lúc hộp thoại hệ thống hiện lên,
/// tạm dừng cơ chế kéo app lên lại để không làm huỷ hộp thoại.
class AuthenticateParentUseCase {
  AuthenticateParentUseCase(this._auth, this._device);

  final ParentAuthRepository _auth;
  final DeviceControlRepository _device;

  Future<ParentAuthResult> call(String reason) async {
    await _device.suspendGuard(true);
    try {
      return await _auth.authenticate(reason);
    } finally {
      await _device.suspendGuard(false);
    }
  }
}

class ChildReport {
  const ChildReport({required this.child, required this.stats});

  final ChildProfile child;
  final ChildUsageStats stats;
}

/// Danh sách trẻ kèm thống kê tổng hợp — chỉ chạy truy vấn gộp, không tải lịch sử.
class GetChildReportsUseCase {
  GetChildReportsUseCase(this._children, this._logs);

  final ChildRepository _children;
  final UsageLogRepository _logs;

  Future<List<ChildReport>> call() async {
    final (children, stats) = await (
      _children.getChildren(),
      _logs.getUsageStats(),
    ).wait;
    final byChild = {for (final s in stats) s.childId: s};
    final reports = [
      for (final c in children)
        ChildReport(
          child: c,
          stats: byChild[c.id] ?? ChildUsageStats(childId: c.id),
        ),
    ];
    reports.sort((a, b) {
      final la = a.stats.lastUsedAt, lb = b.stats.lastUsedAt;
      if (la == null && lb == null) return a.child.name.compareTo(b.child.name);
      if (la == null) return 1;
      if (lb == null) return -1;
      return lb.compareTo(la);
    });
    return reports;
  }
}

/// Lịch sử chi tiết của một trẻ, tải theo trang.
class GetChildHistoryUseCase {
  GetChildHistoryUseCase(this._logs);
  final UsageLogRepository _logs;

  Future<List<UsageLog>> call(String childId, {int offset = 0}) =>
      _logs.getLogsForChild(
        childId,
        limit: AppConstants.historyPageSize,
        offset: offset,
      );
}

class GetWeakTopicsUseCase {
  GetWeakTopicsUseCase(this._logs);
  final UsageLogRepository _logs;

  Future<List<WeakTopic>> call(String childId) =>
      _logs.getWeakTopics(childId, limit: 5);
}

/// Không xoá dữ liệu khi còn phiên đang chạy (đồng hồ / khoá native vẫn active).
class ActiveSessionExistsException implements Exception {
  const ActiveSessionExistsException();
}

/// Xoá một hồ sơ trẻ và lịch sử gắn với bé (CASCADE + dọn snapshot trong 1 txn).
class DeleteChildUseCase {
  DeleteChildUseCase(this._children, this._active);

  final ChildRepository _children;
  final ActiveSessionRepository _active;

  Future<void> call(String childId) async {
    if (await _active.get() != null) {
      throw const ActiveSessionExistsException();
    }
    await _children.deleteChild(childId);
  }
}

/// Xoá mọi hồ sơ trẻ + lịch sử trên máy. Giữ cài đặt phụ huynh và ngân hàng câu hỏi.
class ClearAllChildrenDataUseCase {
  ClearAllChildrenDataUseCase(this._children, this._active);

  final ChildRepository _children;
  final ActiveSessionRepository _active;

  Future<void> call() async {
    if (await _active.get() != null) {
      throw const ActiveSessionExistsException();
    }
    await _children.deleteAllChildren();
  }
}
