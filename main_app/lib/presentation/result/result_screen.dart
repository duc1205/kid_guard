import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/money_format.dart';
import '../../domain/entities/valued_item.dart';
import '../widgets/common_widgets.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.entry,
    this.fromHistory = false,
  });

  final ScanHistoryEntry entry;
  final bool fromHistory;

  @override
  Widget build(BuildContext context) {
    final result = entry.result;
    final items = result.items;
    final time = DateFormat('dd/MM/yyyy HH:mm').format(entry.createdAt);

    return Scaffold(
      backgroundColor: AppColors.mist,
      appBar: AppBar(
        title: Text(fromHistory ? 'Chi tiết lịch sử' : 'Kết quả định giá'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1F6B4A), Color(0xFF2D8F64)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  result.summary.isNotEmpty
                      ? result.summary
                      : 'Đã nhận diện ${items.length} đồ vật',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        label: 'Tổng ước tính',
                        value: items.isEmpty
                            ? '—'
                            : MoneyFormat.compactRange(
                                result.totalMinVnd,
                                result.totalMaxVnd,
                              ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                    Expanded(
                      child: _Stat(
                        label: 'Số món',
                        value: '${items.length}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Chi tiết từng món',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          if (items.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Không tìm thấy đồ vật có thể định giá trong ảnh.',
              ),
            )
          else
            ...items.map((item) => ValuedItemCard(item: item)),
          if (result.marketNote.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              result.marketNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppColors.ink.withValues(alpha: 0.5),
                  ),
            ),
          ],
          const SizedBox(height: 20),
          if (!fromHistory)
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Quét tiếp'),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }
}
