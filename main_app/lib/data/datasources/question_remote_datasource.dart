import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';

/// Tải file câu hỏi qua HTTPS. Chỉ GET file tĩnh, không gửi dữ liệu nào của trẻ.
class QuestionRemoteDataSource {
  QuestionRemoteDataSource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: _timeout,
              receiveTimeout: _timeout,
              headers: const {'Cache-Control': 'no-cache'},
            ),
          );

  final Dio _dio;
  static const _timeout = Duration(seconds: 15);

  /// Ném [IOException] / [TimeoutException] / [HttpException] nếu lỗi mạng.
  Future<List<int>> fetch(Uri uri) async {
    if (uri.scheme != 'https') {
      throw HttpException('only https is allowed', uri: uri);
    }
    try {
      final res = await _dio.getUri<ResponseBody>(
        uri,
        options: Options(
          responseType: ResponseType.stream,
          validateStatus: (_) => true,
        ),
      );
      if (res.statusCode != 200) {
        throw HttpException('HTTP ${res.statusCode}', uri: uri);
      }
      final body = res.data;
      if (body == null) {
        throw HttpException('empty body', uri: uri);
      }
      final out = BytesBuilder(copy: false);
      await for (final chunk in body.stream) {
        out.add(chunk);
        if (out.length > AppConstants.maxQuestionFileBytes) {
          throw HttpException('file too large', uri: uri);
        }
      }
      return out.takeBytes();
    } on HttpException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } on DioException catch (e) {
      if (e.error is HttpException) throw e.error as HttpException;
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw TimeoutException('timeout', _timeout);
      }
      final status = e.response?.statusCode;
      if (status != null) {
        throw HttpException('HTTP $status', uri: uri);
      }
      throw HttpException(e.message ?? 'network error', uri: uri);
    }
  }
}
