import '../../../domain/entities/user.dart';

/// States for authentication
abstract class AuthState {
  const AuthState();
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during authentication
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);
}

/// User is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Authentication error
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});
}
