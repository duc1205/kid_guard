import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/money_format.dart';
import '../../core/utils/product_search.dart';
import '../../domain/entities/valued_item.dart';
import 'cached_product_image.dart';

IconData categoryIcon(String glyph) {
  return switch (glyph) {
    'phone' => Icons.smartphone_rounded,
    'laptop' => Icons.laptop_mac_rounded,
    'tv' => Icons.tv_rounded,
    'watch' => Icons.watch_rounded,
    'bag' => Icons.shopping_bag_outlined,
    'shoe' => Icons.ice_skating_outlined,
    'mouse' => Icons.mouse_outlined,
    'keyboard' => Icons.keyboard_alt_outlined,
    'vehicle' => Icons.directions_car_filled_outlined,
    'food' => Icons.restaurant_rounded,
    'furniture' => Icons.chair_outlined,
    _ => Icons.inventory_2_outlined,
  };
}

Future<void> showProductSearchSheet(
  BuildContext context,
  ValuedItem item,
) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.panel,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.ink.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tìm kiếm sản phẩm',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                ProductSearch.queryOf(item),
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                      color: AppColors.ink.withValues(alpha: 0.55),
                    ),
              ),
              const SizedBox(height: 16),
              for (final target in ProductSearchTarget.values) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.forest.withValues(alpha: 0.12),
                    child: Icon(
                      switch (target) {
                        ProductSearchTarget.google => Icons.search_rounded,
                        ProductSearchTarget.shopee => Icons.storefront_rounded,
                        ProductSearchTarget.lazada => Icons.shopping_bag_rounded,
                      },
                      color: AppColors.forest,
                    ),
                  ),
                  title: Text(
                    'Mở trên ${target.label}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final ok = await ProductSearch.open(item, target);
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Không mở được trình duyệt'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

class ValuedItemCard extends StatelessWidget {
  const ValuedItemCard({
    super.key,
    required this.item,
    this.showSearch = true,
  });

  final ValuedItem item;
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedProductImage(
            item: item,
            height: 150,
            borderRadius: 14,
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nameVi,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    if (item.brandGuess.isNotEmpty ||
                        item.condition.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        [
                          if (item.brandGuess.isNotEmpty) item.brandGuess,
                          if (item.condition.isNotEmpty) item.condition,
                        ].join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.ink.withValues(alpha: 0.55),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    MoneyFormat.compactRange(item.minVnd, item.maxVnd),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.accentDeep,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'ước tính',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.ink.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _Chip(
                label: '${item.confidencePercent}% · ${item.confidenceLabel}',
                tone: item.confidence >= 0.7
                    ? AppColors.forest
                    : AppColors.accentDeep,
              ),
              if (item.category.isNotEmpty)
                _Chip(
                  label: item.category,
                  tone: AppColors.ink.withValues(alpha: 0.55),
                ),
            ],
          ),
          if (item.reasoning.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              item.reasoning,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.ink.withValues(alpha: 0.62),
                height: 1.35,
              ),
            ),
          ],
          if (showSearch) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => showProductSearchSheet(context, item),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Tìm mua trên web'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.forest,
                  side: BorderSide(
                    color: AppColors.forest.withValues(alpha: 0.35),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.tone});

  final String label;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: tone,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ScanShutterButton extends StatelessWidget {
  const ScanShutterButton({
    super.key,
    required this.onPressed,
    required this.busy,
    required this.enabled,
  });

  final VoidCallback? onPressed;
  final bool busy;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && !busy ? onPressed : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1 : 0.45,
        child: Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: busy
                    ? [Colors.white70, Colors.white54]
                    : const [AppColors.accent, AppColors.accentDeep],
              ),
            ),
            child: Center(
              child: busy
                  ? const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.6,
                        color: AppColors.ink,
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.ink,
                      size: 28,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class ViewfinderFrame extends StatelessWidget {
  const ViewfinderFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _CornerPainter(color: Colors.white.withValues(alpha: 0.85)),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const inset = 48.0;
    const len = 28.0;
    final left = inset;
    final top = size.height * 0.16;
    final right = size.width - inset;
    final bottom = size.height * 0.58;

    canvas.drawLine(Offset(left, top + len), Offset(left, top), paint);
    canvas.drawLine(Offset(left, top), Offset(left + len, top), paint);
    canvas.drawLine(Offset(right - len, top), Offset(right, top), paint);
    canvas.drawLine(Offset(right, top), Offset(right, top + len), paint);
    canvas.drawLine(Offset(left, bottom - len), Offset(left, bottom), paint);
    canvas.drawLine(Offset(left, bottom), Offset(left + len, bottom), paint);
    canvas.drawLine(Offset(right - len, bottom), Offset(right, bottom), paint);
    canvas.drawLine(Offset(right, bottom), Offset(right, bottom - len), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) =>
      oldDelegate.color != color;
}
