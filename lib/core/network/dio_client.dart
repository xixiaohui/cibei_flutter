import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'error_interceptor.dart';
import 'retry_interceptor.dart';
import 'logging_interceptor.dart';
import '../constants/api_endpoints.dart';

Dio createDioClient({CookieJar? cookieJar}) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  if (cookieJar != null) {
    dio.interceptors.add(CookieManager(cookieJar));
  }
  dio.interceptors.add(RetryInterceptor(dio));
  dio.interceptors.add(ErrorInterceptor());
  dio.interceptors.add(LoggingInterceptor());

  return dio;
}
