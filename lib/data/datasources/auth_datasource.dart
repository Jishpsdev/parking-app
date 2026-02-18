import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../core/errors/exceptions.dart';

/// Data source for Firebase Authentication operations
abstract class AuthDataSource {
  /// Sign in with email and password
  Future<auth.User> signInWithEmail({
    required String email,
    required String password,
  });
  
  /// Sign out
  Future<void> signOut();
  
  /// Get current Firebase Auth user
  auth.User? getCurrentAuthUser();
  
  /// Check if user is signed in
  bool isSignedIn();
}

/// Implementation of AuthDataSource using Firebase Auth
class AuthDataSourceImpl implements AuthDataSource {
  final auth.FirebaseAuth _firebaseAuth;
  
  AuthDataSourceImpl({
    required auth.FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;
  
  @override
  Future<auth.User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw ServerException('Sign in failed - no user returned');
      }
      
      return credential.user!;
    } on auth.FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later';
          break;
        default:
          message = 'Authentication failed: ${e.message}';
      }
      throw ServerException(message);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw ServerException('Sign out failed: $e');
    }
  }
  
  @override
  auth.User? getCurrentAuthUser() {
    return _firebaseAuth.currentUser;
  }
  
  @override
  bool isSignedIn() {
    return _firebaseAuth.currentUser != null;
  }
}
