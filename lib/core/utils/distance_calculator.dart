import 'dart:math';
import '../constants/app_constants.dart';

/// Utility class for distance calculations
/// Follows Single Responsibility Principle
class DistanceCalculator {
  // Prevent instantiation
  DistanceCalculator._();
  
  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in meters
  static double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double earthRadius = 6371000; // meters
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }
  
  /// Check if user is within geofence radius
  static bool isWithinRadius({
    required double userLat,
    required double userLon,
    required double targetLat,
    required double targetLon,
    double radius = AppConstants.defaultGeofenceRadius,
  }) {
    final double distance = calculateDistance(
      lat1: userLat,
      lon1: userLon,
      lat2: targetLat,
      lon2: targetLon,
    );
    
    return distance <= radius;
  }
  
  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
