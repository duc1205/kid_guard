import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';
import '../../widgets/parent_revoke_button.dart';

/// Hết giờ: trẻ bắt buộc trả lời 1 câu hỏi A/B/C/D.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selected;
  bool _submitting = false;

  Future<void> _submit() async {
    final index = _selected;
    if (index == null) return;
    setState(() => _submitting = true);
    final controller = DependenciesScope.of(context).guardController;
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final correct = await controller.answer(index);
    if (correct) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: Text(l10n.quizCorrect),
        ),
      );
    }
    if (mounted) setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final controller = DependenciesScope.of(context).guardController;
    final question = controller.session?.currentQuestion;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    if (question == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                if (controller.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.quizLoadError(controller.error!),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                const ParentRevokeButton(),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                const Icon(Icons.alarm_rounded, color: AppColors.danger),
                const SizedBox(width: 8),
                Text(
                  l10n.quizTimeUp,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.danger,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(l10n.quizInstruction),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Tag(question.subject, AppColors.primary),
                _Tag(l10n.questionType(question.type), AppColors.kid),
              ],
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  question.text,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < question.options.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _OptionTile(
                  letter: optionLetters[i],
                  text: question.options[i],
                  selected: _selected == i,
                  onTap: _submitting
                      ? null
                      : () => setState(() => _selected = i),
                ),
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _selected == null || _submitting ? null : _submit,
              child: Text(l10n.quizSubmit),
            ),
            const SizedBox(height: 8),
            const Center(child: ParentRevokeButton(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.w700),
    ),
  );
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.letter,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String letter;
  final String text;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: selected
                    ? AppColors.primary
                    : const Color(0xFFEDEFF5),
                child: Text(
                  letter,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16, height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
