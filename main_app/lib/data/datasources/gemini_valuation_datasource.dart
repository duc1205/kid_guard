import 'dart:convert';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../domain/entities/valued_item.dart';
import 'api_key_store.dart';

class ValuationException implements Exception {
  ValuationException(this.message);
  final String message;

  @override
  String toString() => message;
}

class GeminiValuationDatasource {
  GeminiValuationDatasource({this.modelName = 'gemini-3.6-flash'});

  final String modelName;

  GenerativeModel? _cachedModel;
  String? _cachedApiKey;

  static const _systemPrompt = '''
Bạn là chuyên gia định giá đồ vật tại thị trường Việt Nam (VND).
Nhiệm vụ: nhìn ảnh từ camera người dùng, nhận diện từng đồ vật nhìn thấy rõ,
suy luận thương hiệu/model nếu có dấu hiệu, đánh giá tình trạng, rồi ước tính
khoảng giá mua-bán thực tế tại Việt Nam (tháng gần đây).

Quy tắc:
- Chỉ liệt kê đồ vật thật sự nhìn thấy trong ảnh (không bịa).
- Bỏ qua người, biển báo giao thông, nền nhà/cửa nếu không phải hàng hóa.
- Giá bằng VND số nguyên, khoảng min_vnd–max_vnd hợp lý.
- confidence từ 0 đến 1 (độ chắc chắn nhận diện + định giá).
- Trả lời bằng tiếng Việt trong các trường mô tả.
- reasoning ngắn: vì sao ra mức giá đó.
''';

  GenerativeModel _modelFor(String apiKey) {
    if (_cachedModel != null && _cachedApiKey == apiKey) {
      return _cachedModel!;
    }
    final model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.2,
        responseMimeType: 'application/json',
        responseSchema: Schema.object(
          properties: {
            'summary': Schema.string(
              description: 'Tóm tắt ngắn các đồ vật trong ảnh',
            ),
            'market_note': Schema.string(
              description: 'Ghi chú về độ tin cậy / thị trường VN',
            ),
            'items': Schema.array(
              items: Schema.object(
                properties: {
                  'name_vi': Schema.string(),
                  'name_en': Schema.string(),
                  'category': Schema.string(),
                  'condition': Schema.string(),
                  'brand_guess': Schema.string(),
                  'min_vnd': Schema.integer(),
                  'max_vnd': Schema.integer(),
                  'confidence': Schema.number(),
                  'reasoning': Schema.string(),
                  'search_query': Schema.string(
                    description:
                        'Từ khóa tìm kiếm ngắn để mua hàng VN (vd: Lenovo chuột có dây đỏ)',
                  ),
                },
                requiredProperties: [
                  'name_vi',
                  'min_vnd',
                  'max_vnd',
                  'confidence',
                  'reasoning',
                ],
              ),
            ),
          },
          requiredProperties: ['items', 'summary'],
        ),
      ),
    );
    _cachedModel = model;
    _cachedApiKey = apiKey;
    return model;
  }

  Future<ValuationResult> valueFromImage({
    required Uint8List jpegBytes,
    List<String> detectionHints = const [],
  }) async {
    final apiKey = await ApiKeyStore.read();
    if (apiKey == null || apiKey.isEmpty) {
      throw ValuationException(
        'Chưa cấu hình kết nối định giá. Vào Cài đặt để thêm khóa API.',
      );
    }

    final model = _modelFor(apiKey);

    final hintText = detectionHints.isEmpty
        ? ''
        : '\nGợi ý nhận diện thô (có thể sai): ${detectionHints.join(', ')}.';

    final response = await model.generateContent([
      Content.multi([
        TextPart(
          'Phân tích ảnh này và trả JSON định giá theo schema.'
          ' Thị trường tham chiếu: Việt Nam, đơn vị VND.$hintText',
        ),
        DataPart('image/jpeg', jpegBytes),
      ]),
    ]);

    final text = response.text?.trim();
    if (text == null || text.isEmpty) {
      throw ValuationException(
        'Không phân tích được ảnh. Thử chụp rõ hơn hoặc đủ sáng hơn.',
      );
    }

    try {
      final decoded = jsonDecode(_stripCodeFence(text));
      if (decoded is! Map) {
        throw const FormatException('JSON không phải object');
      }
      return ValuationResult.fromJson(Map<String, dynamic>.from(decoded));
    } on FormatException {
      throw ValuationException('Không đọc được kết quả định giá. Thử lại.');
    }
  }

  static String _stripCodeFence(String text) {
    var t = text.trim();
    if (t.startsWith('```')) {
      t = t.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
      t = t.replaceFirst(RegExp(r'\s*```$'), '');
    }
    return t.trim();
  }
}
