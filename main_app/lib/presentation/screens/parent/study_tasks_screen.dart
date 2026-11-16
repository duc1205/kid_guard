import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/child_profile.dart';
import '../../../domain/entities/study_task.dart';
import '../../../domain/usecases/register_child.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';

/// Bố mẹ đặt việc học hằng ngày cho bé (đã ở trong khu vực phụ huynh).
class StudyTasksScreen extends StatefulWidget {
  const StudyTasksScreen({super.key, required this.child});

  final ChildProfile child;

  @override
  State<StudyTasksScreen> createState() => _StudyTasksScreenState();
}

class _StudyTasksScreenState extends State<StudyTasksScreen> {
  List<StudyTask>? _tasks;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tasks = await DependenciesScope.of(
      context,
    ).getStudyTasks(widget.child.id);
    if (mounted) setState(() => _tasks = tasks);
  }

  Future<void> _edit([StudyTask? task]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => _TaskEditorScreen(child: widget.child, task: task),
      ),
    );
    if (saved == true) await _load();
  }

  Future<void> _delete(StudyTask task) async {
    final l10n = context.l10n;
    final deps = DependenciesScope.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.studyTaskDeleteTitle(task.title)),
        content: Text(l10n.studyTaskDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.studyTaskDeleteConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await deps.deleteStudyTask(task.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tasks = _tasks;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.studyTasksTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.studyTasksAdd),
      ),
      body: tasks == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
              children: [
                Text(
                  l10n.studyTasksIntro(widget.child.name),
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                if (tasks.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(l10n.studyTasksEmpty),
                    ),
                  ),
                for (final t in tasks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(16, 6, 4, 6),
                        leading: Icon(
                          t.kind == StudyTaskKind.timer
                              ? Icons.timer_rounded
                              : Icons.fact_check_rounded,
                          color: t.kind == StudyTaskKind.timer
                              ? AppColors.kid
                              : AppColors.primary,
                        ),
                        title: Text(t.title),
                        subtitle: Text(_summary(l10n, t)),
                        onTap: () => _edit(t),
                        trailing: IconButton(
                          tooltip: l10n.studyTaskDeleteConfirm,
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () => _delete(t),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

String _summary(AppLocalizations l10n, StudyTask t) {
  final reward = l10n.duration(t.reward);
  return t.kind == StudyTaskKind.timer
      ? l10n.studyTaskSummaryTimer(l10n.duration(t.duration!), reward)
      : l10n.studyTaskSummaryCheck(reward);
}

class _TaskEditorScreen extends StatefulWidget {
  const _TaskEditorScreen({required this.child, this.task});

  final ChildProfile child;
  final StudyTask? task;

  @override
  State<_TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<_TaskEditorScreen> {
  late final _title = TextEditingController(text: widget.task?.title ?? '');
  late StudyTaskKind _kind = widget.task?.kind ?? StudyTaskKind.check;
  late int _duration =
      (widget.task?.duration ?? AppConstants.defaultTaskDuration).inMinutes;
  late int _reward =
      (widget.task?.reward ?? AppConstants.defaultTaskReward).inMinutes;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _suggest(String title, StudyTaskKind kind) => setState(() {
    _title.text = title;
    _kind = kind;
    _error = null;
  });

  Future<void> _save() async {
    final deps = DependenciesScope.of(context);
    final l10n = context.l10n;
    setState(() => (_saving = true, _error = null));
    try {
      await deps.saveStudyTask(
        existing: widget.task,
        childId: widget.child.id,
        title: _title.text,
        kind: _kind,
        reward: Duration(minutes: _reward),
        duration: Duration(minutes: _duration),
      );
      if (mounted) Navigator.of(context).pop(true);
    } on ValidationException catch (e) {
      if (mounted) setState(() => _error = l10n.validation(e.error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final suggestions = [
      (l10n.studyTaskSuggestHomework, StudyTaskKind.check),
      (l10n.studyTaskSuggestReading, StudyTaskKind.timer),
      (l10n.studyTaskSuggestVocabulary, StudyTaskKind.timer),
      (l10n.studyTaskSuggestWriting, StudyTaskKind.check),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? l10n.studyTasksAdd : l10n.studyTasksEdit,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(l10n.studyTaskTitleLabel, style: _label),
            const SizedBox(height: 8),
            TextField(
              controller: _title,
              maxLength: AppConstants.maxTaskTitleLength,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: l10n.studyTaskTitleHint,
                errorText: _error,
                counterText: '',
              ),
            ),
            if (widget.task == null) ...[
              const SizedBox(height: 8),
              Text(
                l10n.studyTaskSuggestions,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (title, kind) in suggestions)
                    ActionChip(
                      label: Text(title),
                      onPressed: () => _suggest(title, kind),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Text(l10n.studyTaskKindLabel, style: _label),
            const SizedBox(height: 8),
            SegmentedButton<StudyTaskKind>(
              segments: [
                ButtonSegment(
                  value: StudyTaskKind.check,
                  icon: const Icon(Icons.fact_check_rounded),
                  label: Text(l10n.studyTaskKindCheck),
                ),
                ButtonSegment(
                  value: StudyTaskKind.timer,
                  icon: const Icon(Icons.timer_rounded),
                  label: Text(l10n.studyTaskKindTimer),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (s) => setState(() => _kind = s.first),
            ),
            const SizedBox(height: 8),
            Text(
              _kind == StudyTaskKind.timer
                  ? l10n.studyTaskKindTimerHint
                  : l10n.studyTaskKindCheckHint,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            if (_kind == StudyTaskKind.timer) ...[
              const SizedBox(height: 24),
              Text(l10n.studyTaskDurationLabel, style: _label),
              const SizedBox(height: 8),
              _MinuteChoices(
                values: AppConstants.taskDurationChoices,
                selected: _duration,
                onSelected: (m) => setState(() => _duration = m),
              ),
            ],
            const SizedBox(height: 24),
            Text(l10n.studyTaskRewardLabel, style: _label),
            const SizedBox(height: 8),
            _MinuteChoices(
              values: AppConstants.taskRewardChoices,
              selected: _reward,
              onSelected: (m) => setState(() => _reward = m),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l10n.settingsSave),
            ),
          ],
        ),
      ),
    );
  }
}

class _MinuteChoices extends StatelessWidget {
  const _MinuteChoices({
    required this.values,
    required this.selected,
    required this.onSelected,
  });

  final List<int> values;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Giá trị cũ không nằm trong danh sách vẫn hiện để không bị đổi ngầm.
    final all = {...values, selected}.toList()..sort();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final m in all)
          ChoiceChip(
            label: Text(l10n.duration(Duration(minutes: m))),
            selected: m == selected,
            onSelected: (_) => onSelected(m),
          ),
      ],
    );
  }
}

const _label = TextStyle(fontWeight: FontWeight.w700, fontSize: 15);
