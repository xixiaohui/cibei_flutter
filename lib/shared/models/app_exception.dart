sealed class AppException implements Exception {
  String get userMessage;
  const AppException();
}

class NetworkException extends AppException {
  @override
  String get userMessage => '网络连接失败，请检查网络设置';
  const NetworkException();
}

class AuthException extends AppException {
  @override
  String get userMessage => '登录已过期，请重新登录';
  const AuthException();
}

class ServerException extends AppException {
  final String message;
  @override
  String get userMessage => message;
  const ServerException(this.message);
}

class NotFoundException extends AppException {
  @override
  String get userMessage => '内容未找到';
  const NotFoundException();
}

class CacheException extends AppException {
  @override
  String get userMessage => '缓存读取失败';
  const CacheException();
}
