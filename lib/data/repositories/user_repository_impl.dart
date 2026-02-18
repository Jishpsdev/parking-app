import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/user.dart' as domain;
import '../../domain/entities/user_type.dart';
import '../../domain/repositories/user_repository.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;
  final auth.FirebaseAuth _auth;
  
  UserRepositoryImpl({
    required FirebaseFirestore firestore,
    required auth.FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _auth = firebaseAuth;
  
  @override
  Future<Result<domain.User>> getCurrentUser() async {
    try {
      final authUser = _auth.currentUser;
      if (authUser == null) {
        return const Left(ServerFailure('User not authenticated'));
      }
      
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(authUser.uid)
          .get();
      
      if (!doc.exists) {
        // Create user document if it doesn't exist
        // Default to regular user type
        final newUser = domain.User((b) => b
          ..id = authUser.uid
          ..name = authUser.displayName ?? 'User'
          ..userType = UserType.regular);
        
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(authUser.uid)
            .set(newUser.toFirestore());
        
        return Right(newUser);
      }
      
      final user = domain.User.fromFirestore(doc.data()!, doc.id);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<domain.User>> getUserById(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      
      if (!doc.exists) {
        return const Left(ServerFailure('User not found'));
      }
      
      final user = domain.User.fromFirestore(doc.data()!, doc.id);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<domain.User>> getUserByEmail(String email) async {
    try {
      // Email is no longer in Firestore, it's in Firebase Auth
      // This method is deprecated - use signInWithEmail instead
      return const Left(ServerFailure(
        'getUserByEmail is deprecated - use Firebase Auth sign in instead',
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<void>> updateUserLocation({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'currentLocation': {
          'latitude': latitude,
          'longitude': longitude,
        },
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<void>> updateActiveReservation({
    required String userId,
    String? reservationId,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'activeReservationId': reservationId,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Stream<Result<domain.User>> watchUser(String userId) {
    try {
      return _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .snapshots()
          .map((doc) {
        if (!doc.exists) {
          return const Left<Failure, domain.User>(
            ServerFailure('User not found'),
          );
        }
        
        final user = domain.User.fromFirestore(doc.data()!, doc.id);
        return Right<Failure, domain.User>(user);
      });
    } on ServerException catch (e) {
      return Stream.value(Left(ServerFailure(e.message)));
    } catch (e) {
      return Stream.value(Left(ServerFailure('Unexpected error: $e')));
    }
  }
}
