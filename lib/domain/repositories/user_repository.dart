import '../../core/utils/result.dart';
import '../entities/user.dart';

/// Repository interface for User
abstract class UserRepository {
  /// Get current user
  Future<Result<User>> getCurrentUser();
  
  /// Get user by ID
  Future<Result<User>> getUserById(String userId);
  
  /// Get user by email address
  Future<Result<User>> getUserByEmail(String email);
  
  /// Update user location
  Future<Result<void>> updateUserLocation({
    required String userId,
    required double latitude,
    required double longitude,
  });
  
  /// Update user's active reservation
  Future<Result<void>> updateActiveReservation({
    required String userId,
    String? reservationId,
  });
  
  /// Watch user changes (real-time)
  Stream<Result<User>> watchUser(String userId);
}
