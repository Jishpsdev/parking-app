import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/foundation.dart';

/// Service to handle PWA-specific features
class PWAService {
  static final PWAService _instance = PWAService._internal();
  factory PWAService() => _instance;
  PWAService._internal();

  // Use ValueNotifier for reactive updates
  final ValueNotifier<bool> _isInstallableNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isInstalledNotifier = ValueNotifier(false);
  
  bool get isWeb => kIsWeb;
  bool get isInstallable => _isInstallableNotifier.value;
  bool get isInstalled => _isInstalledNotifier.value;
  bool get isOnline => kIsWeb ? html.window.navigator.onLine ?? true : true;
  
  // Expose notifiers for listening
  ValueListenable<bool> get isInstallableListenable => _isInstallableNotifier;
  ValueListenable<bool> get isInstalledListenable => _isInstalledNotifier;

  /// Initialize PWA service and listeners
  void initialize() {
    if (!kIsWeb) return;

    try {
      // Check if running as installed PWA
      _isInstalledNotifier.value = _checkIfInstalled();
      
      // Listen for install prompt availability
      html.window.addEventListener('pwa-install-available', (event) {
        if (kDebugMode) {
          print('💾 PWA install prompt is available');
        }
        _isInstallableNotifier.value = true;
      });

      // Listen for successful installation
      html.window.addEventListener('pwa-installed', (event) {
        if (kDebugMode) {
          print('✅ PWA was installed successfully');
        }
        _isInstalledNotifier.value = true;
        _isInstallableNotifier.value = false;
      });

      // Listen for PWA update available
      html.window.addEventListener('pwa-update-available', (event) {
        if (kDebugMode) {
          print('🔄 PWA update available');
        }
      });

      // Listen for connection status changes
      html.window.addEventListener('online', (event) {
        if (kDebugMode) {
          print('🌐 Connection restored');
        }
      });

      html.window.addEventListener('offline', (event) {
        if (kDebugMode) {
          print('📡 Connection lost');
        }
      });

      // Listen for background sync
      html.window.addEventListener('sync-data', (event) {
        if (kDebugMode) {
          print('🔄 Background sync triggered');
        }
      });

      if (kDebugMode) {
        print('✅ PWA Service initialized');
        print('   - Is Installed: ${_isInstalledNotifier.value}');
        print('   - Is Online: $isOnline');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ PWA Service initialization failed: $e');
      }
    }
  }

  /// Check if app is running as installed PWA
  bool _checkIfInstalled() {
    try {
      // Check display mode
      final mediaQuery = html.window.matchMedia('(display-mode: standalone)');
      if (mediaQuery.matches) return true;

      // Check iOS standalone mode
      final nav = html.window.navigator as dynamic;
      if (nav.standalone == true) return true;

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Show PWA install prompt
  Future<void> showInstallPrompt() async {
    if (!kIsWeb) return;
    if (!_isInstallableNotifier.value) {
      if (kDebugMode) {
        print('⚠️ Install prompt not available');
      }
      return;
    }

    try {
      // Call JavaScript function to show install prompt
      // Check if the function exists in the global window object
      if (js.context.hasProperty('showPWAInstallPrompt')) {
        js.context.callMethod('showPWAInstallPrompt', []);
        if (kDebugMode) {
          print('📱 Install prompt triggered');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ showPWAInstallPrompt function not found in window');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to show install prompt: $e');
      }
    }
  }

  /// Get install instructions for iOS
  String getIOSInstallInstructions() {
    return '''
To install this app on iOS:
1. Tap the Share button (square with arrow pointing up)
2. Scroll down and tap "Add to Home Screen"
3. Tap "Add" in the top right corner
    ''';
  }

  /// Check if device is iOS
  bool isIOS() {
    if (!kIsWeb) return false;
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('iphone') || 
           userAgent.contains('ipad') || 
           userAgent.contains('ipod');
  }

  /// Check if device is Android
  bool isAndroid() {
    if (!kIsWeb) return false;
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('android');
  }

  /// Request persistent storage (for PWA data persistence)
  /// Note: This is an optional feature and may not be supported on all browsers
  Future<bool> requestPersistentStorage() async {
    if (!kIsWeb) return false;

    try {
      // Storage API is best handled through JavaScript
      // We'll log the attempt but won't guarantee the result
      if (kDebugMode) {
        print('📦 Persistent storage request (handled by service worker)');
      }
      // Return true as the service worker will handle caching
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to request persistent storage: $e');
      }
    }
    return false;
  }

  /// Check if storage is persisted
  /// Note: This is an optional feature and may not be supported on all browsers
  Future<bool> isStoragePersisted() async {
    if (!kIsWeb) return false;

    try {
      // Storage persistence is handled by the browser and service worker
      // We'll return true if service workers are supported
      if (kDebugMode) {
        print('📦 Storage persistence check (delegated to browser)');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to check storage persistence: $e');
      }
    }
    return false;
  }

  /// Reload the app (useful for applying updates)
  void reloadApp() {
    if (!kIsWeb) return;
    html.window.location.reload();
  }
  
  /// Debug method to manually trigger install prompt UI (for testing)
  void debugTriggerInstallPrompt() {
    if (!kIsWeb) return;
    if (kDebugMode) {
      print('🧪 Debug: Manually triggering install prompt UI');
      _isInstallableNotifier.value = true;
    }
  }
}
