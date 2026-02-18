/// Base exception class
class AppException implements Exception {
  final String message;
  
  const AppException(this.message);
  
  @override
  String toString() => message;
}

/// Server exception
class ServerException extends AppException {
  const ServerException(super.message);
}

/// Cache exception
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Location exception
class LocationException extends AppException {
  const LocationException(super.message);
}

/// Permission exception
class PermissionException extends AppException {
  const PermissionException(super.message);
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException(super.message);
}
