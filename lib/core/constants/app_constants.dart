class AppConstants {
  // Prevent instantiation
  AppConstants._();
  
  // Geofencing
  static const double defaultGeofenceRadius = 100.0; // meters
  static const double locationAccuracyThreshold = 50.0; // meters
  
  // Reservation
  static const Duration reservationTimeout = Duration(minutes: 15);
  static const Duration reservationWarningTime = Duration(minutes: 5);
  
  // Firebase Collections
  static const String parkingLotsCollection = 'parking_lots';
  static const String slotsSubCollection = 'slots';
  static const String usersCollection = 'users';
  static const String reservationsCollection = 'reservations';
  static const String bookingsCollection = 'slot_bookings';
  
  // Slot Settings
  static const int defaultCarSlots = 20;
  static const int defaultBikeSlots = 30;
  
  // Location Update Interval
  static const Duration locationUpdateInterval = Duration(seconds: 10);
  
  // Error Messages
  static const String locationPermissionDenied = 'Location permission denied';
  static const String locationServiceDisabled = 'Location service is disabled';
  static const String userNotInRange = 'You must be within the parking area to reserve a slot';
  static const String slotNotAvailable = 'This slot is no longer available';
  static const String noSlotsAvailable = 'No slots available at the moment';
  static const String reservationExpired = 'Your reservation has expired';
  
  // Success Messages
  static const String slotReservedSuccess = 'Slot reserved successfully';
  static const String slotOccupiedSuccess = 'Slot marked as occupied';
  static const String slotReleasedSuccess = 'Slot released successfully';
}
