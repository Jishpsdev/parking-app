import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/firebase_options.dart';
import 'core/di/injection_container.dart';
import 'core/services/notification_service.dart';
import 'core/services/pwa_service.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/parking_lot/parking_lot_bloc.dart';
import 'presentation/bloc/slot/slot_bloc.dart';
import 'presentation/screens/auth/auth_wrapper.dart';
import 'presentation/widgets/notification_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  // Note: You'll need to run `flutterfire configure` to generate firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  // ⚠️ ONE-TIME DATA POPULATION - COMMENT OUT AFTER FIRST RUN ⚠️
  // Uncomment the line below and run the app ONCE to populate Firestore
  // Then COMMENT IT OUT again to prevent duplicate data
  // await populateSampleParkingData();
  
  // Initialize dependencies
  await initializeDependencies();
  
  // Initialize notification service (non-blocking - don't prevent app startup)
  final notificationService = sl<NotificationService>();
  notificationService.initialize().catchError((e) {
    if (kDebugMode) {
      print('Failed to initialize notifications: $e');
      print('App will continue without push notifications');
    }
  });
  
  // Initialize PWA service (web only)
  if (kIsWeb) {
    try {
      final pwaService = sl<PWAService>();
      pwaService.initialize();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize PWA service: $e');
      }
    }
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<ParkingLotBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<SlotBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Smart Parking System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Material 3 Color Scheme - Black & White
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            brightness: Brightness.light,
            primary: Colors.black,
            onPrimary: Colors.white,
            secondary: Colors.black87,
            onSecondary: Colors.white,
            tertiary: Colors.grey.shade800,
            onTertiary: Colors.white,
            error: Colors.red.shade700,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
            surfaceContainerHighest: Colors.grey.shade100,
            outline: Colors.grey.shade400,
          ),
          useMaterial3: true,
          
          // AppBar theme
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 2,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
            ),
          ),
          
          // Card theme
          cardTheme: CardThemeData(
            elevation: 1,
            surfaceTintColor: Colors.transparent,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          
          // Elevated button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 1,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          // Outlined button theme
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          // Text button theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          
          // Icon button theme
          iconButtonTheme: IconButtonThemeData(
            style: IconButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          ),
          
          // FAB theme
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 6,
          ),
          
          // Input decoration theme
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade700, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade700, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          
          // Divider theme
          dividerTheme: DividerThemeData(
            color: Colors.grey.shade300,
            thickness: 1,
            space: 1,
          ),
          
          // Bottom sheet theme
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
          ),
          
          // Dialog theme
          dialogTheme: DialogThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          
          // Snackbar theme
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.black,
            contentTextStyle: const TextStyle(color: Colors.white),
            behavior: SnackBarBehavior.floating,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          
          // Progress indicator theme
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.black,
          ),
          
          // Tab bar theme
          tabBarTheme: const TabBarThemeData(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
        builder: (context, child) {
          return PushNotificationListener(
            child: child ?? const SizedBox(),
          );
        },
        home: const AuthWrapper(),
      ),
    );
  }
}
