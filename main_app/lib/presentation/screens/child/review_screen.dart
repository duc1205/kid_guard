import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';

/// Trả lời sai: cho trẻ xem đáp án đúng và gợi ý ôn tập.
/// Chỉ có duy nhất nút OK (không có nút bỏ qua, Back bị chặn) → bấm OK là khoá máy.
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final controller = DependenciesScope.of(context).guardController;
    final session = controller.session!;
    final q = session.currentQuestion;
    final chosen = session.chosenIndex;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.sentiment_dissatisfied_rounded,
                size: 64,
                color: AppColors.danger,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.reviewWrong,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    if (q != null) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${q.subject} · ${q.topic}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                q.text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (chosen != null)
                                _AnswerLine(
                                  label: l10n.reviewYourChoice,
                                  text:
                                      '${optionLetters[chosen]}. ${q.options[chosen]}',
                                  color: AppColors.danger,
                                  icon: Icons.close_rounded,
                                ),
                              _AnswerLine(
                                label: l10n.reviewCorrectAnswer,
                                text:
                                    '${optionLetters[q.answerIndex]}. ${q.options[q.answerIndex]}',
                                color: AppColors.success,
                                icon: Icons.check_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        color: const Color(0xFFFFF8E6),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.lightbulb_rounded,
                                color: Color(0xFFF5A623),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.reviewSuggestionTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      q.suggestion,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      l10n.reviewLockNotice,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.danger,
                ),
                onPressed: _busy
                    ? null
                    : () async {
                        setState(() => _busy = true);
                        await controller.acknowledgeWrongAnswer();
                      },
                child: Text(l10n.commonOk),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({
    required this.label,
    required this.text,
    required this.color,
    required this.icon,
  });
  final String label;
  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
