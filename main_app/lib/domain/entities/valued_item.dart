import 'package:freezed_annotation/freezed_annotation.dart';

part 'valued_item.freezed.dart';
part 'valued_item.g.dart';

@freezed
abstract class ValuedItem with _$ValuedItem {
  const ValuedItem._();

  const factory ValuedItem({
    required String nameVi,
    @Default('') String nameEn,
    @Default('') String category,
    @Default('') String condition,
    @Default('') String brandGuess,
    required int minVnd,
    required int maxVnd,
    @Default(0.5) double confidence,
    @Default('') String reasoning,

    /// Từ khóa tìm kiếm do model gợi ý (ưu tiên dùng khi mở web).
    @Default('') String searchQuery,
    /// URL ảnh minh họa sản phẩm từ web.
    @Default('') String imageUrl,
  }) = _ValuedItem;

  factory ValuedItem.fromJson(Map<String, dynamic> json) =>
      _$ValuedItemFromJson(_normalizeItemJson(json));

  int get midVnd => ((minVnd + maxVnd) / 2).round();

  int get confidencePercent => (confidence * 100).round().clamp(0, 100);

  String get confidenceLabel {
    if (confidence >= 0.8) return 'Chắc chắn';
    if (confidence >= 0.55) return 'Khá chắc';
    return 'Ước lượng';
  }

  String get categoryGlyph {
    final hay =
        '${category.toLowerCase()} ${nameVi.toLowerCase()} ${nameEn.toLowerCase()}';
    if (hay.contains('điện thoại') ||
        hay.contains('phone') ||
        hay.contains('iphone')) {
      return 'phone';
    }
    if (hay.contains('laptop') ||
        hay.contains('macbook') ||
        hay.contains('máy tính')) {
      return 'laptop';
    }
    if (hay.contains('tv') || hay.contains('ti vi')) return 'tv';
    if (hay.contains('đồng hồ') || hay.contains('watch')) return 'watch';
    if (hay.contains('túi') || hay.contains('bag')) return 'bag';
    if (hay.contains('giày') || hay.contains('shoe')) return 'shoe';
    if (hay.contains('chuột') || hay.contains('mouse')) return 'mouse';
    if (hay.contains('bàn phím') || hay.contains('keyboard')) return 'keyboard';
    if (hay.contains('xe') || hay.contains('car') || hay.contains('moto')) {
      return 'vehicle';
    }
    if (hay.contains('đồ ăn') || hay.contains('food') || hay.contains('trái')) {
      return 'food';
    }
    if (hay.contains('ghế') ||
        hay.contains('bàn') ||
        hay.contains('sofa') ||
        hay.contains('nội thất')) {
      return 'furniture';
    }
    return 'box';
  }

  /// Query dùng để mở tìm kiếm web.
  String get effectiveSearchQuery {
    if (searchQuery.trim().isNotEmpty) return searchQuery.trim();
    return [
      brandGuess,
      nameVi,
    ].where((s) => s.trim().isNotEmpty).join(' ').trim();
  }
}

@freezed
abstract class ValuationResult with _$ValuationResult {
  const ValuationResult._();

  const factory ValuationResult({
    required List<ValuedItem> items,
    @Default('') String summary,
    @Default('') String marketNote,
  }) = _ValuationResult;

  factory ValuationResult.fromJson(Map<String, dynamic> json) =>
      _$ValuationResultFromJson(_normalizeResultJson(json));

  int get totalMinVnd => items.fold<int>(0, (s, i) => s + i.minVnd);

  int get totalMaxVnd => items.fold<int>(0, (s, i) => s + i.maxVnd);

  int get totalMidVnd => items.fold<int>(0, (s, i) => s + i.midVnd);
}

@freezed
abstract class ScanHistoryEntry with _$ScanHistoryEntry {
  const factory ScanHistoryEntry({
    required String id,
    required DateTime createdAt,
    required ValuationResult result,
  }) = _ScanHistoryEntry;

  factory ScanHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$ScanHistoryEntryFromJson(json);
}

Map<String, dynamic> _normalizeItemJson(Map<String, dynamic> json) {
  double conf = 0.5;
  final rawConf = json['confidence'];
  if (rawConf is num) {
    conf = rawConf.toDouble();
    if (conf > 1) conf = conf / 100.0;
  }

  return {
    'nameVi': (json['name_vi'] ?? json['nameVi'] ?? 'Không rõ').toString(),
    'nameEn': (json['name_en'] ?? json['nameEn'] ?? '').toString(),
    'category': (json['category'] ?? '').toString(),
    'condition': (json['condition'] ?? '').toString(),
    'brandGuess': (json['brand_guess'] ?? json['brandGuess'] ?? '').toString(),
    'minVnd': _asInt(json['min_vnd'] ?? json['minVnd']),
    'maxVnd': _asInt(json['max_vnd'] ?? json['maxVnd']),
    'confidence': conf.clamp(0.0, 1.0),
    'reasoning': (json['reasoning'] ?? json['note'] ?? '').toString(),
    'searchQuery': (json['search_query'] ?? json['searchQuery'] ?? '')
        .toString(),
    'imageUrl': (json['image_url'] ?? json['imageUrl'] ?? '').toString(),
  };
}

Map<String, dynamic> _normalizeResultJson(Map<String, dynamic> json) {
  final rawItems = json['items'];
  final items = <Map<String, dynamic>>[];
  if (rawItems is List) {
    for (final e in rawItems) {
      if (e is Map) {
        items.add(_normalizeItemJson(Map<String, dynamic>.from(e)));
      }
    }
  }
  items.sort(
    (a, b) => (((b['minVnd'] as int) + (b['maxVnd'] as int)) ~/ 2).compareTo(
      ((a['minVnd'] as int) + (a['maxVnd'] as int)) ~/ 2,
    ),
  );
  return {
    'items': items,
    'summary': (json['summary'] ?? '').toString(),
    'marketNote': (json['market_note'] ?? json['marketNote'] ?? '').toString(),
  };
}

int _asInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.round();
  if (v is String) {
    final cleaned = v.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 0;
  }
  return 0;
}
