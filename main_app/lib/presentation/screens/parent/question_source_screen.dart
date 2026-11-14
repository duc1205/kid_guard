import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/question_bank.dart';
import '../../../domain/usecases/question_bank_usecases.dart';
import '../../l10n_ext.dart';
import '../../widgets/dependencies_scope.dart';

/// Phụ huynh xem / cập nhật / đổi nguồn tải câu hỏi.
class QuestionSourceScreen extends StatefulWidget {
  const QuestionSourceScreen({super.key});

  @override
  State<QuestionSourceScreen> createState() => _QuestionSourceScreenState();
}

class _QuestionSourceScreenState extends State<QuestionSourceScreen> {
  @override
  void initState() {
    super.initState();
    DependenciesScope.of(context).questionBankController.load();
  }

  String _resultMessage(QuestionSyncResult r) {
    final l10n = context.l10n;
    return switch (r.status) {
      QuestionSyncStatus.updated => l10n.qsResultUpdated(r.version ?? 0),
      QuestionSyncStatus.upToDate => l10n.qsResultUpToDate,
      QuestionSyncStatus.failed => switch (r.error!) {
        QuestionSyncError.network => l10n.qsErrorNetwork,
        QuestionSyncError.invalidManifest => l10n.qsErrorManifest,
        QuestionSyncError.invalidQuestions => l10n.qsErrorQuestions,
        QuestionSyncError.checksumMismatch => l10n.qsErrorChecksum,
      },
    };
  }

  void _show(QuestionSyncResult r) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_resultMessage(r)),
        backgroundColor: r.status == QuestionSyncStatus.failed
            ? AppColors.danger
            : null,
      ),
    );
  }

  Future<void> _sync() async {
    final c = DependenciesScope.of(context).questionBankController;
    _show(await c.syncNow());
  }

  Future<void> _changeSource(QuestionBankInfo info) async {
    final c = DependenciesScope.of(context).questionBankController;
    final picked = await showDialog<_SourceChoice>(
      context: context,
      builder: (_) =>
          _SourceDialog(initial: info.isDefaultSource ? '' : info.sourceUrl),
    );
    if (picked == null) return;
    _show(await c.changeSource(picked.url));
  }

  @override
  Widget build(BuildContext context) {
    final c = DependenciesScope.of(context).questionBankController;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.qsTitle)),
      body: ListenableBuilder(
        listenable: c,
        builder: (context, _) {
          final info = c.info;
          if (info == null) {
            return const Center(child: CircularProgressIndicator());
          }
          const total = AppConstants.maxGrade - AppConstants.minGrade + 1;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.cloud_outlined),
                        title: Text(l10n.qsSource),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              info.isDefaultSource
                                  ? l10n.qsDefaultSource
                                  : l10n.qsCustomSource,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SelectableText(
                              info.sourceUrl,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.tag_rounded),
                        title: Text(l10n.qsVersion),
                        trailing: Text(
                          info.version > 0 ? '${info.version}' : '–',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.download_done_rounded),
                        title: Text(l10n.qsDownloaded),
                        subtitle: info.downloadedGrades == 0
                            ? Text(l10n.qsBundledOnly)
                            : null,
                        trailing: Text(
                          '${info.downloadedGrades}/$total',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.schedule_rounded),
                        title: Text(l10n.qsLastSync),
                        trailing: Text(
                          info.lastSyncedAt == null
                              ? l10n.qsNever
                              : formatDateTime(info.lastSyncedAt!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: c.busy ? null : _sync,
                icon: c.busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync_rounded),
                label: Text(l10n.qsSyncNow),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: c.busy ? null : () => _changeSource(info),
                icon: const Icon(Icons.edit_rounded),
                label: Text(l10n.qsChangeSource),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.qsHelp,
                style: const TextStyle(color: Colors.black54, height: 1.4),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Kết quả hộp thoại: `url == null` = quay về nguồn mặc định.
class _SourceChoice {
  const _SourceChoice(this.url);
  final String? url;
}

class _SourceDialog extends StatefulWidget {
  const _SourceDialog({required this.initial});
  final String initial;

  @override
  State<_SourceDialog> createState() => _SourceDialogState();
}

class _SourceDialogState extends State<_SourceDialog> {
  late final _text = TextEditingController(text: widget.initial);
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = context.l10n;
    final value = _text.text.trim();
    final uri = Uri.tryParse(value);
    final error = value.isEmpty || uri == null || !uri.hasAuthority
        ? QuestionSourceError.invalidUrl
        : uri.scheme != 'https'
        ? QuestionSourceError.insecureUrl
        : null;
    if (error != null) {
      setState(
        () => _error = error == QuestionSourceError.insecureUrl
            ? l10n.qsInsecureUrl
            : l10n.qsInvalidUrl,
      );
      return;
    }
    Navigator.pop(context, _SourceChoice(value));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.qsChangeTitle),
      content: TextField(
        controller: _text,
        autofocus: true,
        keyboardType: TextInputType.url,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: 'https://…/manifest.json',
          errorText: _error,
          errorMaxLines: 2,
        ),
        onSubmitted: (_) => _save(),
      ),
      actionsOverflowButtonSpacing: 4,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, const _SourceChoice(null)),
          child: Text(l10n.qsUseDefault),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.qsSave)),
      ],
    );
  }
}
