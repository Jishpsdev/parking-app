import '../../core/utils/result.dart';

/// Repository interface for Notification management
abstract class NotificationRepository {
  /// Save FCM token for a user
  Future<Result<void>> saveFCMToken({
    required String userId,
    required String token,
  });
  
  /// Get FCM token for a user
  Future<Result<String?>> getFCMToken(String userId);
  
  /// Delete FCM token for a user
  Future<Result<void>> deleteFCMToken(String userId);
}
