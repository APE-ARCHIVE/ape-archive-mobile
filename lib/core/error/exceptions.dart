/// Base exception class
class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'AppException: $message (Status: $statusCode)';
}

/// Server/API exception
class ServerException extends AppException {
  ServerException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Network exception
class NetworkException extends AppException {
  NetworkException({
    super.message = 'No internet connection',
    super.statusCode,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Authentication exception
class AuthException extends AppException {
  AuthException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'AuthException: $message (Status: $statusCode)';
}

/// Cache exception
class CacheException extends AppException {
  CacheException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Validation exception
class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Permission exception
class PermissionException extends AppException {
  PermissionException({
    required super.message,
    super.statusCode,
  });

  @override
  String toString() => 'PermissionException: $message';
}
