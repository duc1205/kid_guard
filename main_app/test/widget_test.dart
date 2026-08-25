import 'package:flutter_test/flutter_test.dart';
import 'package:main_app/core/utils/money_format.dart';
import 'package:main_app/core/utils/product_search.dart';
import 'package:main_app/domain/entities/valued_item.dart';

void main() {
  test('ValuedItem parses API json + search query', () {
    final item = ValuedItem.fromJson({
      'name_vi': 'Chuột Lenovo',
      'brand_guess': 'Lenovo',
      'min_vnd': 30000,
      'max_vnd': 70000,
      'confidence': 0.85,
      'reasoning': 'Chuột văn phòng',
      'search_query': 'chuột có dây Lenovo đỏ',
      'category': 'Phụ kiện',
      'condition': 'đã qua sử dụng',
    });

    expect(item.nameVi, 'Chuột Lenovo');
    expect(item.effectiveSearchQuery, 'chuột có dây Lenovo đỏ');
    expect(item.categoryGlyph, 'mouse');
  });

  test('ProductSearch builds external uris', () {
    const item = ValuedItem(
      nameVi: 'Chuột Lenovo',
      brandGuess: 'Lenovo',
      minVnd: 1,
      maxVnd: 2,
      searchQuery: 'chuột Lenovo có dây',
    );
    final google = ProductSearch.uriFor(item, ProductSearchTarget.google);
    final shopee = ProductSearch.uriFor(item, ProductSearchTarget.shopee);
    expect(google.host, 'www.google.com');
    expect(google.queryParameters['q'], 'chuột Lenovo có dây');
    expect(shopee.host, 'shopee.vn');
  });

  test('MoneyFormat compact', () {
    expect(MoneyFormat.compact(3200000), '3.2tr');
    expect(MoneyFormat.vnd(1500000), '1.500.000₫');
  });
}
