import '../../core/utils/result.dart';
import '../entities/geo_point.dart';

/// Repository interface for Location services
/// Abstracts location service implementation
abstract class LocationRepository {
  /// Get current location
  Future<Result<GeoPoint>> getCurrentLocation();
  
  /// Check if location service is enabled
  Future<Result<bool>> isLocationServiceEnabled();
  
  /// Request location permission
  Future<Result<bool>> requestLocationPermission();
  
  /// Check location permission status
  Future<Result<bool>> hasLocationPermission();
  
  /// Watch location changes (real-time)
  Stream<Result<GeoPoint>> watchLocation();
  
  /// Calculate distance between two points
  double calculateDistance(GeoPoint from, GeoPoint to);
  
  /// Check if point is within radius
  bool isWithinRadius({
    required GeoPoint userLocation,
    required GeoPoint targetLocation,
    required double radiusInMeters,
  });
}
