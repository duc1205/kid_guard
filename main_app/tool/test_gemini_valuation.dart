import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

/// Smoke-test valuation path used by the app (same model + prompt shape).
Future<void> main() async {
  final defines = jsonDecode(
    File('.dart_defines.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final apiKey = defines['GEMINI_API_KEY'] as String;
  final bytes = Uint8List.fromList(File('/tmp/gemini_phone.jpg').readAsBytesSync());

  final model = GenerativeModel(
    model: 'gemini-3.6-flash',
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 0.2,
      responseMimeType: 'application/json',
    ),
  );

  final response = await model.generateContent([
    Content.multi([
      TextPart(
        'Bạn là chuyên gia định giá VN. Trả JSON '
        '{"summary":"...","items":[{"name_vi":"...","min_vnd":0,"max_vnd":0,'
        '"confidence":0.0,"reasoning":"...","brand_guess":"...","condition":"..."}]}',
      ),
      DataPart('image/jpeg', bytes),
    ]),
  ]);

  final text = response.text;
  if (text == null || text.isEmpty) {
    stderr.writeln('FAIL: empty response');
    exit(1);
  }
  final parsed = jsonDecode(text) as Map<String, dynamic>;
  final items = parsed['items'] as List<dynamic>? ?? [];
  stdout.writeln('OK — Gemini returned ${items.length} item(s)');
  stdout.writeln('summary: ${parsed['summary']}');
  for (final raw in items) {
    final it = Map<String, dynamic>.from(raw as Map);
    stdout.writeln(
      '- ${it['name_vi']}: ${it['min_vnd']} – ${it['max_vnd']} VND '
      '(${it['brand_guess']}, ${it['condition']})',
    );
  }
}
