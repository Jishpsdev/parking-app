/// Events for authentication
abstract class AuthEvent {
  const AuthEvent();
}

/// Event to login with email and password
class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailEvent({
    required this.email,
    required this.password,
  });
}

/// Event to logout
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Event to check if user is already logged in
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}
