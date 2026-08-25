import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../core/theme/app_theme.dart';
import '../../data/datasources/product_image_service.dart';
import '../../domain/entities/valued_item.dart';
import 'common_widgets.dart';

/// Cache manager riêng cho ảnh sản phẩm (giữ 30 ngày, tối đa 300 file).
class ProductImageCacheManager {
  ProductImageCacheManager._();

  static const key = 'scan_price_product_images';

  static final instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 300,
    ),
  );
}

/// Ảnh minh họa sản phẩm: ưu tiên URL đã lưu, không thì resolve + cache disk.
class CachedProductImage extends StatefulWidget {
  const CachedProductImage({
    super.key,
    required this.item,
    this.width,
    this.height = 160,
    this.borderRadius = 14,
    this.fit = BoxFit.cover,
  });

  final ValuedItem item;
  final double? width;
  final double height;
  final double borderRadius;
  final BoxFit fit;

  @override
  State<CachedProductImage> createState() => _CachedProductImageState();
}

class _CachedProductImageState extends State<CachedProductImage> {
  late Future<String?> _urlFuture;

  @override
  void initState() {
    super.initState();
    _urlFuture = _resolve();
  }

  @override
  void didUpdateWidget(covariant CachedProductImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.imageUrl != widget.item.imageUrl ||
        oldWidget.item.effectiveSearchQuery !=
            widget.item.effectiveSearchQuery) {
      _urlFuture = _resolve();
    }
  }

  Future<String?> _resolve() async {
    final existing = widget.item.imageUrl.trim();
    if (existing.isNotEmpty) return existing;
    return ProductImageService.findUrl(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: FutureBuilder<String?>(
          future: _urlFuture,
          builder: (context, snap) {
            final url = snap.data;
            if (snap.connectionState != ConnectionState.done) {
              return _Placeholder(
                item: widget.item,
                loading: true,
              );
            }
            if (url == null || url.isEmpty) {
              return _Placeholder(item: widget.item);
            }
            return CachedNetworkImage(
              imageUrl: url,
              cacheManager: ProductImageCacheManager.instance,
              width: widget.width ?? double.infinity,
              height: widget.height,
              fit: widget.fit,
              fadeInDuration: const Duration(milliseconds: 200),
              placeholder: (_, _) => _Placeholder(
                item: widget.item,
                loading: true,
              ),
              errorWidget: (_, _, _) => _Placeholder(item: widget.item),
            );
          },
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.item, this.loading = false});

  final ValuedItem item;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.forest.withValues(alpha: 0.08),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.forest,
                ),
              )
            : Icon(
                categoryIcon(item.categoryGlyph),
                color: AppColors.forest.withValues(alpha: 0.45),
                size: 28,
              ),
      ),
    );
  }
}
