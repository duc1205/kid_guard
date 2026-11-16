import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/parent_pin_usecases.dart';
import '../l10n_ext.dart';
import 'dependencies_scope.dart';
import 'parent_auth_flow.dart';

/// Hỏi người lớn trước một thao tác cần quyền phụ huynh. [reason] là câu mô
/// tả thao tác (đã dịch).
/// - Có mã PIN phụ huynh → nhập PIN (hoặc mật khẩu máy nếu phụ huynh cho phép).
/// - Bản cũ chưa tạo PIN → mật khẩu máy như trước (không ai bị khoá ngoài).
Future<ParentAuthResult> askParent(
  BuildContext context, {
  required String reason,
}) async {
  final deps = DependenciesScope.of(context);
  if (!await deps.parentPin.hasPin()) return deps.authenticateDevice(reason);
  final allowDevice = await deps.parentPin.deviceAuthAllowed();
  if (!context.mounted) return ParentAuthResult.cancelled;
  final result = await showDialog<ParentAuthResult>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _PinDialog(reason: reason, allowDevice: allowDevice),
  );
  return result ?? ParentAuthResult.cancelled;
}

/// Đảm bảo đã có mã PIN phụ huynh; chưa có thì mở màn tạo PIN.
/// Máy đã từng dùng (có hồ sơ bé) → phải qua mật khẩu máy trước khi tạo, để
/// bé không tự đặt PIN trên bản cũ. Trả về true nếu đã có PIN.
Future<bool> ensureParentPin(BuildContext context) async {
  final deps = DependenciesScope.of(context);
  if (await deps.parentPin.hasPin()) return true;
  if (!context.mounted) return false;
  final l10n = context.l10n;
  final usedBefore = (await deps.guardController.savedChildren()).isNotEmpty;
  if (usedBefore && await deps.parentAuth.isAvailable()) {
    final r = await deps.authenticateDevice(l10n.authReasonCreatePin);
    if (r != ParentAuthResult.success) {
      if (context.mounted) showParentAuthMessage(context, r);
      return false;
    }
  }
  if (!context.mounted) return false;
  final created = await Navigator.of(
    context,
  ).push<bool>(MaterialPageRoute(builder: (_) => const CreatePinScreen()));
  return created == true;
}

class _PinDialog extends StatefulWidget {
  const _PinDialog({required this.reason, required this.allowDevice});
  final String reason;
  final bool allowDevice;

  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  String _pin = '';
  String? _error;
  bool _busy = false;
  DateTime? _lockedUntil;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    DependenciesScope.of(context).verifyParentPin.lockedFor().then(_lock);
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _lock(Duration? d) {
    if (!mounted || d == null) return;
    setState(() => _lockedUntil = DateTime.now().add(d));
    _tick?.cancel();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final until = _lockedUntil;
      if (until == null || !DateTime.now().isBefore(until)) {
        _tick?.cancel();
        setState(() => (_lockedUntil = null, _error = null));
      } else {
        setState(() {});
      }
    });
  }

  bool get _locked => _lockedUntil != null;

  Future<void> _submit() async {
    if (_busy || _locked || _pin.length < PinPolicy.minLength) return;
    setState(() => _busy = true);
    final l10n = context.l10n;
    final result = await DependenciesScope.of(context).verifyParentPin(_pin);
    if (!mounted) return;
    switch (result) {
      case PinOk():
        Navigator.of(context).pop(ParentAuthResult.success);
        return;
      case PinWrong(:final attemptsLeft, :final lockedFor):
        setState(() => _error = l10n.pinWrong(attemptsLeft));
        _lock(lockedFor);
      case PinLockedOut(:final remaining):
        _lock(remaining);
    }
    setState(() => (_pin = '', _busy = false));
  }

  Future<void> _useDevice() async {
    final deps = DependenciesScope.of(context);
    final r = await deps.authenticateDevice(widget.reason);
    if (!mounted) return;
    if (r == ParentAuthResult.success) {
      Navigator.of(context).pop(r);
    } else {
      showParentAuthMessage(context, r);
    }
  }

  void _forgot() {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.pinForgotTitle),
        content: Text(l10n.pinForgotBody),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.commonOk),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final until = _lockedUntil;
    final status = until != null
        ? l10n.pinLocked(
            l10n.duration(
              Duration(seconds: until.difference(DateTime.now()).inSeconds + 1),
            ),
          )
        : _error;
    return Dialog.fullscreen(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                tooltip: l10n.commonCancel,
                icon: const Icon(Icons.close_rounded),
                onPressed: () =>
                    Navigator.of(context).pop(ParentAuthResult.cancelled),
              ),
            ),
            Expanded(
              child: PinPad(
                title: l10n.pinEnterTitle,
                subtitle: widget.reason,
                value: _pin,
                error: status,
                enabled: !_busy && !_locked,
                onChanged: (edit) =>
                    setState(() => (_pin = edit(_pin), _error = null)),
                onSubmit: _submit,
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                if (widget.allowDevice)
                  TextButton.icon(
                    onPressed: _useDevice,
                    icon: const Icon(Icons.fingerprint_rounded),
                    label: Text(l10n.pinUseDevice),
                  ),
                TextButton(onPressed: _forgot, child: Text(l10n.pinForgot)),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// Màn tạo / đổi mã PIN phụ huynh: nhập 2 lần cho khớp. Trả về true khi đã lưu.
class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key, this.changing = false});

  final bool changing;

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  String _pin = '';
  String? _first;
  String? _error;
  bool _busy = false;

  Future<void> _submit() async {
    if (_busy || _pin.length < PinPolicy.minLength) return;
    final l10n = context.l10n;
    final first = _first;
    if (first == null) {
      final error = PinPolicy.validate(_pin);
      if (error != null) {
        setState(() => (_error = _pinError(l10n, error), _pin = ''));
        return;
      }
      setState(() => (_first = _pin, _pin = '', _error = null));
      return;
    }
    if (first != _pin) {
      setState(() => (_first = null, _pin = '', _error = l10n.pinMismatch));
      return;
    }
    setState(() => _busy = true);
    await DependenciesScope.of(context).setParentPin(_pin);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.pinCreated)));
    Navigator.of(context).pop(true);
  }

  static String _pinError(AppLocalizations l10n, PinError e) => switch (e) {
    PinError.length || PinError.digitsOnly => l10n.pinErrorLength,
    PinError.tooSimple => l10n.pinErrorTooSimple,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final confirming = _first != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.changing ? l10n.pinChangeTitle : l10n.pinCreateTitle,
        ),
      ),
      body: SafeArea(
        child: PinPad(
          title: confirming ? l10n.pinConfirmTitle : l10n.pinCreatePrompt,
          subtitle: confirming ? null : l10n.pinCreateBody,
          value: _pin,
          error: _error,
          enabled: !_busy,
          onChanged: (edit) =>
              setState(() => (_pin = edit(_pin), _error = null)),
          onSubmit: _submit,
        ),
      ),
    );
  }
}

/// Bàn phím số + các chấm thể hiện số chữ số đã nhập. Nhận cả bàn phím thật
/// (máy tính): số, Backspace, Enter.
class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    this.error,
    required this.enabled,
    required this.onChanged,
    required this.onSubmit,
  });

  final String title;
  final String? subtitle;
  final String value;
  final String? error;
  final bool enabled;

  /// Nhận một phép sửa (thêm / xoá chữ số) áp lên giá trị mới nhất, để bấm
  /// nhanh nhiều phím trong cùng một khung hình không bị mất số.
  final ValueChanged<String Function(String current)> onChanged;
  final VoidCallback onSubmit;

  void _digit(String d) {
    if (!enabled) return;
    onChanged((v) => v.length < PinPolicy.maxLength ? v + d : v);
  }

  void _back() {
    if (!enabled) return;
    onChanged((v) => v.isEmpty ? v : v.substring(0, v.length - 1));
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final ch = e.character;
    if (ch != null && RegExp(r'^\d$').hasMatch(ch)) {
      _digit(ch);
    } else if (e.logicalKey == LogicalKeyboardKey.backspace) {
      _back();
    } else if (e.logicalKey == LogicalKeyboardKey.enter ||
        e.logicalKey == LogicalKeyboardKey.numpadEnter) {
      onSubmit();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSubmit = enabled && value.length >= PinPolicy.minLength;
    return Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (
                      var i = 0;
                      i < (value.length < 4 ? 4 : value.length);
                      i++
                    )
                      Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < value.length
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 48,
                  child: Center(
                    child: error == null
                        ? null
                        : Text(
                            error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.danger,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                for (final row in const [
                  ['1', '2', '3'],
                  ['4', '5', '6'],
                  ['7', '8', '9'],
                ])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (final d in row)
                        _Key(
                          onTap: enabled ? () => _digit(d) : null,
                          child: Text(d),
                        ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Key(
                      onTap: enabled ? _back : null,
                      child: const Icon(Icons.backspace_outlined),
                    ),
                    _Key(
                      onTap: enabled ? () => _digit('0') : null,
                      child: const Text('0'),
                    ),
                    _Key(
                      filled: true,
                      onTap: canSubmit ? onSubmit : null,
                      child: const Icon(Icons.arrow_forward_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.child, this.onTap, this.filled = false});
  final Widget child;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final fg = filled
        ? Colors.white
        : (onTap == null ? AppColors.textTertiary : AppColors.textPrimary);
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: filled
            ? (onTap == null
                  ? AppColors.primary.withValues(alpha: 0.35)
                  : AppColors.primary)
            : Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 72,
            height: 72,
            child: Center(
              child: IconTheme(
                data: IconThemeData(color: fg),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: fg,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
