import 'package:flutter/material.dart';

import '../../domain/repositories/repositories.dart';
import '../l10n_ext.dart';

/// Hiển thị thông báo phù hợp sau khi xác thực người lớn.
void showParentAuthMessage(BuildContext context, ParentAuthResult result) {
  final message = switch (result) {
    ParentAuthResult.success => null,
    ParentAuthResult.failed => context.l10n.authFailed,
    ParentAuthResult.notAvailable => context.l10n.authNotAvailable,
  };
  if (message == null) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
