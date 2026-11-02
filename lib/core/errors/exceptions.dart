class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation error']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Not found']);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Forbidden']);
}
