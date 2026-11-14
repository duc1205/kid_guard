import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/usecases/register_child.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';

/// Trẻ nhập tên, ngày sinh và lớp đang học (1–12) trước khi được dùng máy.
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
      firstDate: DateTime(now.year - 25),
      lastDate: now,
      initialDatePickerMode: DatePickerMode.year,
      helpText: context.l10n.registerDobPick,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _submit() async {
    final controller = DependenciesScope.of(context).guardController;
    final l10n = context.l10n;
    setState(() => (_submitting = true, _error = null));
    try {
      if (!await controller.isParentLockAvailable()) {
        if (mounted) setState(() => _error = l10n.registerNeedsScreenLock);
        return;
      }
      await controller.startForChild(
        name: _name.text,
        dateOfBirth: _dob,
        grade: _grade,
      );
      // _Root tự chuyển sang màn đếm giờ và đóng màn này.
    } on ValidationException catch (e) {
      if (mounted) setState(() => _error = l10n.validation(e.error));
    } catch (e) {
      if (mounted) setState(() => _error = l10n.registerErrorGeneric('$e'));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(
              l10n.registerGreeting,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(l10n.registerIntro, style: theme.textTheme.bodyLarge),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 18,
                  ),
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
                  g <= AppConstants.maxGrade;
                  g++
                )
                  _GradeChip(
                    grade: g,
                    selected: _grade == g,
                    onTap: () => setState(() => _grade = g),
                  ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: const TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
          ],
        ),
      ),
    );
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
    final level = grade <= 5
        ? l10n.registerLevelPrimary
        : grade <= 9
        ? l10n.registerLevelLowerSecondary
        : l10n.registerLevelUpperSecondary;
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
              l10n.registerGradeChip(grade),
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
