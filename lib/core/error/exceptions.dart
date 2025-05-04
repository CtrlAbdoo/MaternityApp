/// Base exception for data layer
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic stackTrace;

  AppException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: [$code] $message';
}

/// Server exceptions (API, Firebase, etc.)
class ServerException extends AppException {
  ServerException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Cache exceptions (local storage)
class CacheException extends AppException {
  CacheException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Network exceptions (internet connectivity)
class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Authentication exceptions
class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Input validation exceptions
class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Permission exceptions
class PermissionException extends AppException {
  PermissionException({
    required super.message,
    super.code,
    super.stackTrace,
  });
} 