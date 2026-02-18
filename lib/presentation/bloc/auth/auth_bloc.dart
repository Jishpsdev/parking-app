import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/datasources/auth_datasource.dart';
import '../../../domain/usecases/get_current_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for managing authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthDataSource _authDataSource;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final NotificationService _notificationService;
  static const String _userIdKey = 'logged_in_user_id';

  AuthBloc({
    required AuthDataSource authDataSource,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required NotificationService notificationService,
  })  : _authDataSource = authDataSource,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _notificationService = notificationService,
        super(const AuthInitial()) {
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLoginWithEmail(
    LoginWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Sign in with Firebase Auth
      await _authDataSource.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      
      // Get user data from Firestore
      final result = await _getCurrentUserUseCase();
      
      await result.fold(
        (failure) async {
          emit(AuthError(message: failure.message));
        },
        (user) async {
          // Save user ID to shared preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_userIdKey, user.id);
          
          // Set user in notification service (non-blocking)
          _notificationService.setUser(user.id).catchError((e) {
            if (kDebugMode) {
              print('Failed to set user in notification service: $e');
            }
          });
          
          emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    // Clear user from notification service (non-blocking)
    _notificationService.clearUser().catchError((e) {
      if (kDebugMode) {
        print('Failed to clear user from notification service: $e');
      }
    });
    
    // Sign out from Firebase Auth
    await _authDataSource.signOut();
    
    // Clear user ID from shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    
    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Check if user is signed in with Firebase Auth
      final isSignedIn = _authDataSource.isSignedIn();
      
      if (!isSignedIn) {
        // Clear any stale session data
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_userIdKey);
        emit(const AuthUnauthenticated());
        return;
      }

      // User is signed in, fetch their data
      final result = await _getCurrentUserUseCase();
      
      await result.fold(
        (failure) async {
          // Failed to get user data, sign out
          await _authDataSource.signOut();
          emit(const AuthUnauthenticated());
        },
        (user) async {
          // Set user in notification service (non-blocking)
          _notificationService.setUser(user.id).catchError((e) {
            if (kDebugMode) {
              print('Failed to set user in notification service: $e');
            }
          });
          
          // Successfully restored session
          emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }
}
