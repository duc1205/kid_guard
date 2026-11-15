import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/child_profile.dart';
import '../../../domain/usecases/register_child.dart';
import '../../../domain/repositories/repositories.dart';
import '../../controllers/guard_controller.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/parent_auth_flow.dart';

/// Trẻ chọn tên đã lưu, hoặc nhập tên, ngày sinh và lớp đang học trước khi được dùng máy.
/// Thông tin đã lưu chỉ người lớn sửa được (khu vực phụ huynh).
class ChildRegisterScreen extends StatefulWidget {
  const ChildRegisterScreen({super.key});

  @override
  State<ChildRegisterScreen> createState() => _ChildRegisterScreenState();
}

class _ChildRegisterScreenState extends State<ChildRegisterScreen> {
  final _name = TextEditingController();
  DateTime? _dob;
  int? _grade;
  bool _submitting = false;
  String? _error;

  /// `null` = đang tải danh sách bé đã lưu.
  List<ChildProfile>? _saved;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    DependenciesScope.of(context).guardController.savedChildren().then(
      _onSavedLoaded,
      onError: (Object _) => _onSavedLoaded(const []),
    );
  }

  /// Chưa có hồ sơ nào → giữ màn chờ, xác thực phụ huynh rồi mới hiện form
  /// (tránh lộ danh sách trống phía sau hộp thoại hệ thống).
  Future<void> _onSavedLoaded(List<ChildProfile> list) async {
    if (!mounted) return;
    if (list.isNotEmpty) {
      setState(() => (_saved = list, _showForm = false));
      return;
    }
    if (await _openNewChildForm(popOnFail: true) && mounted) {
      setState(() => _saved = list);
    }
  }

  /// Thêm hồ sơ trẻ mới chỉ sau khi phụ huynh xác thực mật khẩu máy.
  /// Trả về `true` nếu xác thực thành công (form đã mở).
  Future<bool> _openNewChildForm({bool popOnFail = false}) async {
    final parent = DependenciesScope.of(context).parentController;
    final result = await parent.authenticate(
      reason: context.l10n.authReasonRegisterChild,
    );
    if (!mounted) return false;
    if (result != ParentAuthResult.success) {
      showParentAuthMessage(context, result);
      if (popOnFail) Navigator.of(context).pop();
      return false;
    }
    setState(() => (_showForm = true, _error = null));
    return true;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _complete =>
      _name.text.trim().length >= 2 && _dob != null && _grade != null;

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 8, 1, 1),
      firstDate: DateTime(now.year - 80),
      lastDate: now,
      initialDatePickerMode: DatePickerMode.year,
      helpText: context.l10n.registerDobPick,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _submit() => _start(
    (controller) => controller.startForChild(
      name: _name.text,
      dateOfBirth: _dob,
      grade: _grade,
    ),
  );

  Future<void> _startSaved(ChildProfile child) =>
      _start((controller) => controller.startForSavedChild(child));

  Future<void> _start(
    Future<void> Function(GuardController controller) begin,
  ) async {
    if (_submitting) return;
    final controller = DependenciesScope.of(context).guardController;
    final l10n = context.l10n;
    setState(() => (_submitting = true, _error = null));
    try {
      if (!await controller.isParentLockAvailable()) {
        if (mounted) setState(() => _error = l10n.registerNeedsScreenLock);
        return;
      }
      await begin(controller);
      // _Root tự chuyển sang màn đếm giờ và đóng màn này.
    } on ValidationException catch (e) {
      if (mounted) setState(() => _error = l10n.validation(e.error));
    } catch (e) {
      if (mounted) setState(() => _error = l10n.registerErrorGeneric('$e'));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _errorText() => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Text(
      _error!,
      style: const TextStyle(
        color: AppColors.danger,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  /// Danh sách bé đã lưu: chạm vào tên là bắt đầu luôn.
  List<Widget> _savedList(ThemeData theme, String allowance) {
    final l10n = context.l10n;
    final now = DateTime.now();
    return [
      Text(
        l10n.registerPickTitle,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 6),
      Text(l10n.registerPickIntro(allowance), style: theme.textTheme.bodyLarge),
      const SizedBox(height: 20),
      for (final c in _saved!) ...[
        Card(
          child: ListTile(
            enabled: !_submitting,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.kid.withValues(alpha: 0.15),
              child: Text(
                c.name.characters.first.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.kid,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            title: Text(
              c.name,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              l10n.dashboardChildInfo(l10n.gradeLabel(c.grade), c.ageAt(now)),
            ),
            trailing: const Icon(
              Icons.play_circle_fill_rounded,
              color: AppColors.kid,
              size: 32,
            ),
            onTap: () => _startSaved(c),
          ),
        ),
        const SizedBox(height: 8),
      ],
      if (_error != null) _errorText(),
      if (_submitting)
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Center(child: CircularProgressIndicator()),
        ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: _submitting ? null : () => _openNewChildForm(),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: Text(l10n.registerAddNew),
      ),
      const SizedBox(height: 16),
      Text(
        l10n.registerSavedHint,
        style: const TextStyle(color: Colors.black54),
        textAlign: TextAlign.center,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final allowance = l10n.duration(
      DependenciesScope.of(context).settingsController.initialAllowance,
    );
    final saved = _saved;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: SafeArea(
        child: saved == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: _showForm
                    ? _form(theme, allowance, canGoBack: saved.isNotEmpty)
                    : _savedList(theme, allowance),
              ),
      ),
    );
  }

  /// Form nhập thông tin bé mới.
  List<Widget> _form(
    ThemeData theme,
    String allowance, {
    required bool canGoBack,
  }) {
    final l10n = context.l10n;
    return [
      Text(
        l10n.registerGreeting,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 6),
      Text(l10n.registerIntro(allowance), style: theme.textTheme.bodyLarge),
      const SizedBox(height: 24),
      _Label(l10n.registerNameLabel),
      TextField(
        controller: _name,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: l10n.registerNameHint,
          prefixIcon: const Icon(Icons.person_rounded),
        ),
        onChanged: (_) => setState(() {}),
      ),
      const SizedBox(height: 20),
      _Label(l10n.registerDobLabel),
      Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _pickDob,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            child: Row(
              children: [
                const Icon(Icons.cake_rounded),
                const SizedBox(width: 12),
                Text(
                  _dob == null ? l10n.registerDobPick : formatDate(_dob!),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: _dob == null ? theme.hintColor : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      _Label(l10n.registerGradeLabel),
      GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.4,
        children: [
          for (
            var g = AppConstants.minGrade;
            g <= AppConstants.maxSchoolGrade;
            g++
          )
            _GradeChip(
              grade: g,
              selected: _grade == g,
              onTap: () => setState(() => _grade = g),
            ),
        ],
      ),
      const SizedBox(height: 16),
      _Label(l10n.registerHigherEducation),
      Row(
        children: [
          for (final (i, g) in const [
            AppConstants.universityGrade,
            AppConstants.postgraduateGrade,
          ].indexed) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 64,
                child: _GradeChip(
                  grade: g,
                  selected: _grade == g,
                  onTap: () => setState(() => _grade = g),
                ),
              ),
            ),
          ],
        ],
      ),
      if (_error != null) _errorText(),
      const SizedBox(height: 28),
      FilledButton(
        style: FilledButton.styleFrom(backgroundColor: AppColors.kid),
        onPressed: _complete && !_submitting ? _submit : null,
        child: _submitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(l10n.registerStart),
      ),
      if (canGoBack) ...[
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: _submitting
              ? null
              : () => setState(() => (_showForm = false, _error = null)),
          icon: const Icon(Icons.people_alt_rounded),
          label: Text(l10n.registerBackToList),
        ),
      ],
    ];
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
    ),
  );
}

class _GradeChip extends StatelessWidget {
  const _GradeChip({
    required this.grade,
    required this.selected,
    required this.onTap,
  });
  final int grade;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final level = switch (grade) {
      <= 5 => l10n.registerLevelPrimary,
      <= 9 => l10n.registerLevelLowerSecondary,
      <= AppConstants.maxSchoolGrade => l10n.registerLevelUpperSecondary,
      AppConstants.universityGrade => l10n.gradeUniversityHint,
      _ => l10n.gradePostgraduateHint,
    };
    return Material(
      color: selected ? AppColors.kid : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.gradeLabel(grade),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : null,
              ),
            ),
            Text(
              level,
              style: TextStyle(
                fontSize: 11,
                color: selected ? Colors.white70 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
