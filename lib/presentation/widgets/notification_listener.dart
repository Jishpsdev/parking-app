import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../core/services/notification_service.dart';

/// Widget that listens to push notifications and displays them
class PushNotificationListener extends StatefulWidget {
  final Widget child;
  
  const PushNotificationListener({
    super.key,
    required this.child,
  });
  
  @override
  State<PushNotificationListener> createState() => _PushNotificationListenerState();
}

class _PushNotificationListenerState extends State<PushNotificationListener> {
  late NotificationService _notificationService;
  
  @override
  void initState() {
    super.initState();
    _notificationService = sl<NotificationService>();
    
    if (kDebugMode) {
      print('📱 PushNotificationListener initialized - setting up stream listener');
    }
    
    // Listen to notification stream
    _notificationService.notificationStream.listen(
      (RemoteMessage message) {
        if (kDebugMode) {
          print('📬 Notification received in listener widget');
          print('   Message ID: ${message.messageId}');
          print('   Title: ${message.notification?.title}');
          print('   Body: ${message.notification?.body}');
          print('   Data: ${message.data}');
        }
        _handleNotification(message);
      },
      onError: (error) {
        if (kDebugMode) {
          print('❌ Error in notification listener widget: $error');
        }
      },
      onDone: () {
        if (kDebugMode) {
          print('⚠️ Notification listener widget stream closed');
        }
      },
    );
    
    if (kDebugMode) {
      print('✅ PushNotificationListener stream listener setup complete');
    }
  }
  
  void _handleNotification(RemoteMessage message) {
    if (kDebugMode) {
      print('🔔 Handling notification in UI');
    }
    
    // Show notification as snackbar when app is in foreground
    if (mounted) {
      final notification = message.notification;
      if (notification != null) {
        if (kDebugMode) {
          print('✅ Displaying notification as SnackBar');
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (notification.title != null)
                  Text(
                    notification.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                if (notification.body != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    notification.body!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ],
            ),
            backgroundColor: Colors.black87,
            duration: const Duration(seconds: 6),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      } else {
        if (kDebugMode) {
          print('⚠️ Notification has no title/body');
          print('   Raw message: $message');
        }
      }
    } else {
      if (kDebugMode) {
        print('⚠️ Widget not mounted, cannot show notification');
      }
    }
  }
  
  void _navigateToNotificationScreen(RemoteMessage message) {
    // TODO: Navigate to appropriate screen based on notification data
    // Example: if message contains 'parkingLotId', navigate to that parking lot
    final data = message.data;
    
    if (data.containsKey('parkingLotId')) {
      // Navigate to parking lot screen
      // Navigator.pushNamed(context, '/parking-lot', arguments: data['parkingLotId']);
    } else if (data.containsKey('slotId')) {
      // Navigate to slot details
      // Navigator.pushNamed(context, '/slot-details', arguments: data['slotId']);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
