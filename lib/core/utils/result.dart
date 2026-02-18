import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Type alias for Result pattern using Either from dartz
/// Left = Failure, Right = Success
typedef Result<T> = Either<Failure, T>;

/// Extension methods for Result
extension ResultX<T> on Result<T> {
  /// Check if result is success
  bool get isSuccess => isRight();
  
  /// Check if result is failure
  bool get isFailure => isLeft();
  
  /// Get value or throw
  T getOrThrow() {
    return fold(
      (failure) => throw Exception(failure.message),
      (value) => value,
    );
  }
  
  /// Get value or null
  T? getOrNull() {
    return fold(
      (_) => null,
      (value) => value,
    );
  }
}
