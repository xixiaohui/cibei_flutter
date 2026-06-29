import 'package:dio/dio.dart';
import '../../shared/models/app_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        handler.next(DioException(
          requestOptions: err.requestOptions,
          error: const NetworkException(),
          type: err.type,
        ));
        return;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          handler.next(DioException(
            requestOptions: err.requestOptions,
            error: const AuthException(),
            type: err.type,
          ));
          return;
        }
        if (statusCode == 404) {
          handler.next(DioException(
            requestOptions: err.requestOptions,
            error: const NotFoundException(),
            type: err.type,
          ));
          return;
        }
        final message = err.response?.data is Map
            ? (err.response?.data['error'] as String?) ?? '服务器错误'
            : '服务器错误';
        handler.next(DioException(
          requestOptions: err.requestOptions,
          error: ServerException(message),
          type: err.type,
        ));
        return;
      default:
        handler.next(err);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
