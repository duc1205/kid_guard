// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'valued_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ValuedItem _$ValuedItemFromJson(Map<String, dynamic> json) => _ValuedItem(
  nameVi: json['nameVi'] as String,
  nameEn: json['nameEn'] as String? ?? '',
  category: json['category'] as String? ?? '',
  condition: json['condition'] as String? ?? '',
  brandGuess: json['brandGuess'] as String? ?? '',
  minVnd: (json['minVnd'] as num).toInt(),
  maxVnd: (json['maxVnd'] as num).toInt(),
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.5,
  reasoning: json['reasoning'] as String? ?? '',
  searchQuery: json['searchQuery'] as String? ?? '',
  imageUrl: json['imageUrl'] as String? ?? '',
);

Map<String, dynamic> _$ValuedItemToJson(_ValuedItem instance) =>
    <String, dynamic>{
      'nameVi': instance.nameVi,
      'nameEn': instance.nameEn,
      'category': instance.category,
      'condition': instance.condition,
      'brandGuess': instance.brandGuess,
      'minVnd': instance.minVnd,
      'maxVnd': instance.maxVnd,
      'confidence': instance.confidence,
      'reasoning': instance.reasoning,
      'searchQuery': instance.searchQuery,
      'imageUrl': instance.imageUrl,
    };

_ValuationResult _$ValuationResultFromJson(Map<String, dynamic> json) =>
    _ValuationResult(
      items: (json['items'] as List<dynamic>)
          .map((e) => ValuedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] as String? ?? '',
      marketNote: json['marketNote'] as String? ?? '',
    );

Map<String, dynamic> _$ValuationResultToJson(_ValuationResult instance) =>
    <String, dynamic>{
      'items': instance.items,
      'summary': instance.summary,
      'marketNote': instance.marketNote,
    };

_ScanHistoryEntry _$ScanHistoryEntryFromJson(Map<String, dynamic> json) =>
    _ScanHistoryEntry(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      result: ValuationResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScanHistoryEntryToJson(_ScanHistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'result': instance.result,
    };
