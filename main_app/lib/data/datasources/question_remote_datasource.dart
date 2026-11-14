import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';

/// Tải file câu hỏi qua HTTPS. Chỉ GET file tĩnh, không gửi dữ liệu nào của trẻ.
class QuestionRemoteDataSource {
  QuestionRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;
  static const _timeout = Duration(seconds: 15);

  /// Ném [IOException] / [TimeoutException] / [HttpException] nếu lỗi mạng.
  Future<List<int>> fetch(Uri uri) async {
    if (uri.scheme != 'https') {
      throw HttpException('only https is allowed', uri: uri);
    }
    final res = await _client
        .get(uri, headers: const {'Cache-Control': 'no-cache'})
        .timeout(_timeout);
    if (res.statusCode != 200) {
      throw HttpException('HTTP ${res.statusCode}', uri: uri);
    }
    if (res.bodyBytes.length > AppConstants.maxQuestionFileBytes) {
      throw HttpException('file too large', uri: uri);
    }
    return res.bodyBytes;
  }
}
