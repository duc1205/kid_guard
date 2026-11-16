import 'package:flutter/material.dart';

import '../l10n_ext.dart';
import 'dependencies_scope.dart';
import 'parent_auth_flow.dart';
import 'parent_gate.dart';

/// Nút dành cho người lớn: nhập mật khẩu máy để thu hồi và thoát chế độ trẻ em.
class ParentRevokeButton extends StatefulWidget {
  const ParentRevokeButton({
    super.key,
    this.label,
    this.color,
    this.filled = false,
  });

  /// Mặc định: nhãn "thu hồi máy" theo ngôn ngữ máy.
  final String? label;
  final Color? color;
  final bool filled;

  @override
  State<ParentRevokeButton> createState() => _ParentRevokeButtonState();
}

class _ParentRevokeButtonState extends State<ParentRevokeButton> {
  bool _busy = false;

  Future<void> _revoke() async {
    setState(() => _busy = true);
    final reason = context.l10n.authReasonRevoke;
    final result = await DependenciesScope.of(context).guardController
        .parentRevoke(authorize: () => askParent(context, reason: reason));
    if (!mounted) return;
    setState(() => _busy = false);
    showParentAuthMessage(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label ?? context.l10n.revokeButton;
    final icon = _busy
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Icon(Icons.admin_panel_settings_rounded);
    if (widget.filled) {
      return FilledButton.icon(
        onPressed: _busy ? null : _revoke,
        icon: icon,
        label: Text(label),
      );
    }
    return TextButton.icon(
      style: TextButton.styleFrom(foregroundColor: widget.color),
      onPressed: _busy ? null : _revoke,
      icon: icon,
      label: Text(label),
    );
  }
}
