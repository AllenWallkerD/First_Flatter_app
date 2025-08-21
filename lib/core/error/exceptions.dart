abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, [this.code]);
  
  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NetworkException extends AppException {
  const NetworkException(String message, [String? code]) : super(message, code);
}

class ServerException extends AppException {
  const ServerException(String message, [String? code]) : super(message, code);
}

class CacheException extends AppException {
  const CacheException(String message, [String? code]) : super(message, code);
}

class BadRequestException extends AppException {
  const BadRequestException(String message, [String? code]) : super(message, code);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(String message, [String? code]) : super(message, code);
}

class ForbiddenException extends AppException {
  const ForbiddenException(String message, [String? code]) : super(message, code);
}

class NotFoundException extends AppException {
  const NotFoundException(String message, [String? code]) : super(message, code);
}
