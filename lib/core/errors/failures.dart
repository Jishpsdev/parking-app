/// Base class for all failures in the application
/// Follows Single Responsibility Principle
abstract class Failure {
  final String message;
  
  const Failure(this.message);
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Location-related failures
class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Slot not available failure
class SlotNotAvailableFailure extends Failure {
  const SlotNotAvailableFailure(super.message);
}

/// User not in range failure
class UserNotInRangeFailure extends Failure {
  const UserNotInRangeFailure(super.message);
}
