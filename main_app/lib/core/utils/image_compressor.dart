import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Nén ảnh trước khi gửi Gemini — giảm upload + thời gian model.
abstract final class ImageCompressor {
  /// Max cạnh dài ~720px, JPEG ~60 — đủ nhận diện, upload Gemini nhanh hơn.
  static Future<Uint8List> forValuation(Uint8List bytes) async {
    if (bytes.lengthInBytes < 120 * 1024) return bytes;
    try {
      final out = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 720,
        minHeight: 720,
        quality: 60,
        format: CompressFormat.jpeg,
        keepExif: false,
      ).timeout(const Duration(milliseconds: 1200));
      if (out.isEmpty) return bytes;
      return out.lengthInBytes < bytes.lengthInBytes
          ? Uint8List.fromList(out)
          : bytes;
    } on TimeoutException {
      return bytes;
    } catch (_) {
      return bytes;
    }
  }
}
