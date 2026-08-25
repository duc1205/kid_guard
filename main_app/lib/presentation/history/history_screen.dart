import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/di/app_locator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/money_format.dart';
import '../../domain/entities/valued_item.dart';
import '../result/result_screen.dart';
import '../widgets/cached_product_image.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, this.active = false});

  final bool active;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<ScanHistoryEntry>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void didUpdateWidget(covariant HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _reload();
    }
  }

  void _reload() {
    setState(() {
      _future = AppLocator.history.getAll();
    });
  }

  Future<void> _clear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa lịch sử?'),
        content: const Text('Toàn bộ lần quét đã lưu sẽ bị xóa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await AppLocator.history.clear();
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mist,
      appBar: AppBar(
        title: const Text('Lịch sử'),
        actions: [
          IconButton(
            tooltip: 'Xóa hết',
            onPressed: _clear,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: FutureBuilder<List<ScanHistoryEntry>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data ?? const <ScanHistoryEntry>[];
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 56,
                      color: AppColors.ink.withValues(alpha: 0.25),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Chưa có lần quét nào',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Kết quả định giá sẽ hiện ở đây sau khi bạn quét.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.ink.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final entry = items[index];
                final first = entry.result.items.isNotEmpty
                    ? entry.result.items.first
                    : null;
                final title = first?.nameVi ??
                    (entry.result.summary.isNotEmpty
                        ? entry.result.summary
                        : 'Lần quét');
                final time =
                    DateFormat('dd/MM HH:mm').format(entry.createdAt);

                return Dismissible(
                  key: ValueKey(entry.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) async {
                    await AppLocator.history.remove(entry.id);
                    _reload();
                  },
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ResultScreen(
                              entry: entry,
                              fromHistory: true,
                            ),
                          ),
                        );
                        _reload();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            if (first != null)
                              CachedProductImage(
                                item: first,
                                width: 56,
                                height: 56,
                                borderRadius: 14,
                              )
                            else
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.forest.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  color: AppColors.forest.withValues(alpha: 0.5),
                                ),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$time · ${entry.result.items.length} món',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.ink
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (entry.result.items.isNotEmpty)
                              Text(
                                MoneyFormat.compactRange(
                                  entry.result.totalMinVnd,
                                  entry.result.totalMaxVnd,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.accentDeep,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
