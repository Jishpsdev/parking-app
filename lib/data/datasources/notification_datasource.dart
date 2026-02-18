import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Data source for Firebase Cloud Messaging
abstract class NotificationDataSource {
  /// Get FCM token for this device
  Future<String?> getToken();
  
  /// Listen to token refresh
  Stream<String> onTokenRefresh();
  
  /// Request notification permission
  Future<bool> requestPermission();
  
  /// Listen to foreground messages
  Stream<RemoteMessage> onMessage();
  
  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic);
  
  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic);
}

/// Implementation of NotificationDataSource using Firebase Messaging
class NotificationDataSourceImpl implements NotificationDataSource {
  final FirebaseMessaging _firebaseMessaging;
  
  // VAPID key for web push notifications
  // Get this from Firebase Console: Project Settings > Cloud Messaging > Web Push certificates
  static const String? _vapidKey = 'BFcCBhgK2TiQM2otInCLmYSprg4QV2FkhF2bCmW4m1ixIIJ8-mX0SVqS9H9hnaqNrtBmYgnah5BzAwIZ9-wECh0'; // TODO: Add your VAPID key here
  
  NotificationDataSourceImpl({
    required FirebaseMessaging firebaseMessaging,
  }) : _firebaseMessaging = firebaseMessaging;
  
  @override
  Future<String?> getToken() async {
    try {
      if (kIsWeb) {
        // For web, VAPID key is required
        if (_vapidKey == null) {
          if (kDebugMode) {
            print('⚠️ VAPID key is not configured for web FCM');
            print('Get your VAPID key from:');
            print('Firebase Console > Project Settings > Cloud Messaging > Web Push certificates');
            print('Then add it to NotificationDataSourceImpl._vapidKey');
          }
          return null;
        }
        return await _firebaseMessaging.getToken(vapidKey: _vapidKey);
      } else {
        // For mobile platforms (Android/iOS)
        return await _firebaseMessaging.getToken();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
      return null;
    }
  }
  
  @override
  Stream<String> onTokenRefresh() {
    return _firebaseMessaging.onTokenRefresh;
  }
  
  @override
  Future<bool> requestPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
             settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Stream<RemoteMessage> onMessage() {
    return FirebaseMessaging.onMessage;
  }
  
  @override
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }
  
  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
