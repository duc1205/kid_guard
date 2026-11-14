import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/entities/question.dart';
import '../models/json_mappers.dart';

/// Ngân hàng câu hỏi đóng gói sẵn trong app (chạy offline): assets/questions/grade_N.json
class QuestionAssetDataSource {
  QuestionAssetDataSource({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final _cache = <int, List<Question>>{};

  Future<List<Question>> load(int grade) async {
    final cached = _cache[grade];
    if (cached != null) return cached;
    final raw = await _bundle.loadString('assets/questions/grade_$grade.json');
    final list = (jsonDecode(raw) as List)
        .map(
          (e) => QuestionMapper.fromAsset(
            Map<String, dynamic>.from(e as Map),
            grade,
          ),
        )
        .toList(growable: false);
    return _cache[grade] = list;
  }
}
