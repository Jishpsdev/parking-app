import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../../data/datasources/notification_datasource.dart';
import '../../domain/repositories/notification_repository.dart';

/// Top-level function to handle background messages
/// Must be a top-level function, not a class method
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background message: ${message.messageId}');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
  }
}

/// Service for managing push notifications
class NotificationService {
  final NotificationDataSource _dataSource;
  final NotificationRepository _repository;
  
  // Stream controller for notification events
  final _notificationController = StreamController<RemoteMessage>.broadcast();
  Stream<RemoteMessage> get notificationStream => _notificationController.stream;
  
  /// Debug method to manually trigger a notification (for testing)
  void debugTriggerNotification(RemoteMessage message) {
    if (kDebugMode) {
      print('🧪 Debug: Manually triggering notification');
      _notificationController.add(message);
    }
  }
  
  // Current FCM token
  String? _currentToken;
  String? get currentToken => _currentToken;
  
  // Current user ID
  String? _currentUserId;
  
  NotificationService({
    required NotificationDataSource dataSource,
    required NotificationRepository repository,
  })  : _dataSource = dataSource,
        _repository = repository;
  
  /// Initialize notification service
  Future<void> initialize() async {
    try {
      // Request permission
      final hasPermission = await _dataSource.requestPermission();
      
      if (!hasPermission) {
        if (kDebugMode) {
          print('Notification permission denied');
        }
        return;
      }
      
      // Get FCM token
      _currentToken = await _dataSource.getToken();
      if (kDebugMode) {
        print('FCM Token: $_currentToken');
      }
      
      // FCM on web requires additional setup (VAPID key, service worker)
      // If token is null on web, it's expected until web FCM is configured
      if (_currentToken == null && kDebugMode) {
        print('FCM Token is null - May need platform-specific configuration');
        print('For Web: Configure VAPID key and service worker');
        print('For iOS: Ensure APNs is configured');
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize notifications: $e');
      }
      // Don't block app startup if notifications fail
      return;
    }
    
    // Listen to token refresh
    _dataSource.onTokenRefresh().listen((newToken) {
      _currentToken = newToken;
      if (kDebugMode) {
        print('FCM Token refreshed: $newToken');
      }
      
      // Update token in Firestore if user is logged in
      if (_currentUserId != null) {
        _saveFCMToken(_currentUserId!, newToken);
      }
    });
    
    // Listen to foreground messages
    if (kDebugMode) {
      print('🎧 Setting up foreground message listener...');
    }
    
    _dataSource.onMessage().listen(
      (RemoteMessage message) {
        if (kDebugMode) {
          print('📨 Foreground message received in NotificationService');
          print('   Message ID: ${message.messageId}');
          print('   Title: ${message.notification?.title}');
          print('   Body: ${message.notification?.body}');
          print('   Data: ${message.data}');
          print('   Has listeners: ${_notificationController.hasListener}');
        }
        
        // Emit to stream for UI to handle
        _notificationController.add(message);
        
        if (kDebugMode) {
          print('   ✅ Message added to notification stream');
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('❌ Error in foreground message listener: $error');
        }
      },
      onDone: () {
        if (kDebugMode) {
          print('⚠️ Foreground message listener stream closed');
        }
      },
    );
    
    if (kDebugMode) {
      print('✅ Foreground message listener setup complete');
    }
    
    // Handle notification when app is opened from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
    
    // Handle notification when app is in background and user taps it
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }
  
  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification tapped: ${message.messageId}');
      print('Data: ${message.data}');
    }
    
    // Emit to stream so UI can navigate appropriately
    _notificationController.add(message);
    
    // TODO: Navigate to appropriate screen based on notification data
    // Example: if notification contains 'slotId', navigate to slot details
  }
  
  /// Subscribe to parking lot notifications
  Future<void> subscribeToParkingLot(String parkingLotId) async {
    try {
      await _dataSource.subscribeToTopic('parking_lot_$parkingLotId');
      if (kDebugMode) {
        print('Subscribed to parking_lot_$parkingLotId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to subscribe to parking lot topic: $e');
      }
    }
  }
  
  /// Unsubscribe from parking lot notifications
  Future<void> unsubscribeFromParkingLot(String parkingLotId) async {
    try {
      await _dataSource.unsubscribeFromTopic('parking_lot_$parkingLotId');
      if (kDebugMode) {
        print('Unsubscribed from parking_lot_$parkingLotId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to unsubscribe from parking lot topic: $e');
      }
    }
  }
  
  /// Subscribe to user-specific notifications
  Future<void> subscribeToUserNotifications(String userId) async {
    try {
      await _dataSource.subscribeToTopic('user_$userId');
      if (kDebugMode) {
        print('Subscribed to user_$userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to subscribe to user topic: $e');
      }
    }
  }
  
  /// Unsubscribe from user-specific notifications
  Future<void> unsubscribeFromUserNotifications(String userId) async {
    try {
      await _dataSource.unsubscribeFromTopic('user_$userId');
      if (kDebugMode) {
        print('Unsubscribed from user_$userId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to unsubscribe from user topic: $e');
      }
    }
  }
  
  /// Save FCM token for current user
  Future<void> _saveFCMToken(String userId, String token) async {
    final result = await _repository.saveFCMToken(
      userId: userId,
      token: token,
    );
    
    result.fold(
      (failure) {
        if (kDebugMode) {
          print('Failed to save FCM token: ${failure.message}');
        }
      },
      (_) {
        if (kDebugMode) {
          print('FCM token saved successfully for user: $userId');
        }
      },
    );
  }
  
  /// Set current user and save FCM token
  Future<void> setUser(String userId) async {
    try {
      _currentUserId = userId;
      
      if (_currentToken != null) {
        await _saveFCMToken(userId, _currentToken!);
      } else {
        if (kDebugMode) {
          print('No FCM token available to save for user: $userId');
        }
      }
      
      // Subscribe to user-specific notifications
      await subscribeToUserNotifications(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Error in setUser: $e');
      }
      // Don't throw - notification issues shouldn't block auth
    }
  }
  
  /// Clear user and unsubscribe from notifications
  Future<void> clearUser() async {
    try {
      if (_currentUserId != null) {
        // Unsubscribe from user notifications
        await unsubscribeFromUserNotifications(_currentUserId!);
        
        // Delete FCM token
        await _repository.deleteFCMToken(_currentUserId!);
        
        _currentUserId = null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in clearUser: $e');
      }
      // Don't throw - notification issues shouldn't block logout
    }
  }
  
  /// Dispose resources
  void dispose() {
    _notificationController.close();
  }
}
