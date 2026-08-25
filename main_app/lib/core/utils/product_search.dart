import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/valued_item.dart';

enum ProductSearchTarget {
  google,
  shopee,
  lazada,
}

extension ProductSearchTargetX on ProductSearchTarget {
  String get label => switch (this) {
    ProductSearchTarget.google => 'Google',
    ProductSearchTarget.shopee => 'Shopee',
    ProductSearchTarget.lazada => 'Lazada',
  };
}

/// Tạo link tìm kiếm sản phẩm ngoài app.
abstract final class ProductSearch {
  static String queryOf(ValuedItem item) => item.effectiveSearchQuery;

  static Uri uriFor(ValuedItem item, ProductSearchTarget target) {
    final q = Uri.encodeComponent(queryOf(item));
    return switch (target) {
      ProductSearchTarget.google => Uri.parse(
        'https://www.google.com/search?tbm=shop&hl=vi&gl=vn&q=$q',
      ),
      ProductSearchTarget.shopee => Uri.parse(
        'https://shopee.vn/search?keyword=$q',
      ),
      ProductSearchTarget.lazada => Uri.parse(
        'https://www.lazada.vn/catalog/?q=$q',
      ),
    };
  }

  static Future<bool> open(ValuedItem item, ProductSearchTarget target) async {
    final uri = uriFor(item, target);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
