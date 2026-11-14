import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/child_profile.dart';
import '../../../domain/usecases/register_child.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';

/// Người lớn sửa thông tin bé (tên, ngày sinh, lớp). Trả về hồ sơ đã sửa khi lưu.
class EditChildScreen extends StatefulWidget {
  const EditChildScreen({super.key, required this.child});

  final ChildProfile child;

  @override
  State<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends State<EditChildScreen> {
  late final _name = TextEditingController(text: widget.child.name);
  late DateTime _dob = widget.child.dateOfBirth;
  late int _grade = widget.child.grade;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(now.year - 80),
      lastDate: now,
      initialDatePickerMode: DatePickerMode.year,
      helpText: context.l10n.registerDobPick,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _save() async {
    final parent = DependenciesScope.of(context).parentController;
    final l10n = context.l10n;
    setState(() => (_saving = true, _error = null));
    try {
      final updated = await parent.updateChild(
        widget.child,
        name: _name.text,
        dateOfBirth: _dob,
        grade: _grade,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.childEditSaved(updated.name))),
      );
      Navigator.of(context).pop(updated);
    } on ValidationException catch (e) {
      if (mounted) setState(() => _error = l10n.validation(e.error));
    } catch (e) {
      if (mounted) setState(() => _error = l10n.registerErrorGeneric('$e'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.childEditTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(l10n.registerNameLabel, style: _labelStyle),
            const SizedBox(height: 8),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_rounded),
              ),
            ),
            const SizedBox(height: 20),
            Text(l10n.registerDobLabel, style: _labelStyle),
            const SizedBox(height: 8),
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
                      Text(formatDate(_dob), style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(l10n.childEditGradeLabel, style: _labelStyle),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              initialValue: _grade,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.school_rounded),
              ),
              items: [
                for (
                  var g = AppConstants.minGrade;
                  g <= AppConstants.maxGrade;
                  g++
                )
                  DropdownMenuItem(value: g, child: Text(l10n.gradeLabel(g))),
              ],
              onChanged: (g) {
                if (g != null) setState(() => _grade = g);
              },
            ),
            const SizedBox(height: 10),
            Text(
              l10n.childEditNote,
              style: const TextStyle(color: Colors.black54),
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
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.settingsSave),
            ),
          ],
        ),
      ),
    );
  }
}

const _labelStyle = TextStyle(fontWeight: FontWeight.w700, fontSize: 15);
