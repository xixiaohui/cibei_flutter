import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';

class ApiClient {
  late final Dio _dio;
  late final CookieJar _cookieJar;

  ApiClient() {
    _cookieJar = CookieJar();
    _dio = createDioClient(cookieJar: _cookieJar);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(path, data: data, cancelToken: cancelToken);
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(path, data: data, cancelToken: cancelToken);
  }

  Future<Response<T>> delete<T>(
    String path, {
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(path, cancelToken: cancelToken);
  }

  void clearCookies() {
    _cookieJar.deleteAll();
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
