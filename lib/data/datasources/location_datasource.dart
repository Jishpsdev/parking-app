import 'package:geolocator/geolocator.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/geo_point.dart';

/// Data source for location services using Geolocator
abstract class LocationDataSource {
  Future<GeoPoint> getCurrentLocation();
  Future<bool> isLocationServiceEnabled();
  Future<bool> requestLocationPermission();
  Future<bool> hasLocationPermission();
  Stream<GeoPoint> watchLocation();
}

class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<GeoPoint> getCurrentLocation() async {
    try {
      // Check if location service is enabled
      final bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const LocationException('Location service is disabled');
      }
      
      // Check permission
      final bool hasPermission = await hasLocationPermission();
      if (!hasPermission) {
        throw const PermissionException('Location permission denied');
      }
      
      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
      
      return GeoPoint((b) => b
        ..latitude = position.latitude
        ..longitude = position.longitude);
    } catch (e) {
      if (e is AppException) rethrow;
      throw LocationException('Failed to get location: $e');
    }
  }
  
  @override
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      throw LocationException('Failed to check location service: $e');
    }
  }
  
  @override
  Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      throw PermissionException('Failed to request permission: $e');
    }
  }
  
  @override
  Future<bool> hasLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Try to request permission
        return await requestLocationPermission();
      }
      
      return true;
    } catch (e) {
      throw PermissionException('Failed to check permission: $e');
    }
  }
  
  @override
  Stream<GeoPoint> watchLocation() {
    try {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
      
      return Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).map((position) {
        return GeoPoint((b) => b
          ..latitude = position.latitude
          ..longitude = position.longitude);
      });
    } catch (e) {
      throw LocationException('Failed to watch location: $e');
    }
  }
}
