import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/notification_repository.dart';

/// Implementation of NotificationRepository
class NotificationRepositoryImpl implements NotificationRepository {
  final FirebaseFirestore _firestore;
  
  NotificationRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;
  
  @override
  Future<Result<void>> saveFCMToken({
    required String userId,
    required String token,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': DateTime.now().toIso8601String(),
      });
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to save FCM token: $e'));
    }
  }
  
  @override
  Future<Result<String?>> getFCMToken(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      
      if (!doc.exists) {
        return const Left(ServerFailure('User not found'));
      }
      
      final data = doc.data();
      final token = data?['fcmToken'] as String?;
      
      return Right(token);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get FCM token: $e'));
    }
  }
  
  @override
  Future<Result<void>> deleteFCMToken(String userId) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'fcmToken': null,
        'fcmTokenUpdatedAt': DateTime.now().toIso8601String(),
      });
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete FCM token: $e'));
    }
  }
}
