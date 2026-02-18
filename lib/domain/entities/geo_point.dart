import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import '../../core/utils/distance_calculator.dart';

part 'geo_point.g.dart';

/// Value Object for geographical coordinates
/// Immutable and contains business logic
abstract class GeoPoint implements Built<GeoPoint, GeoPointBuilder> {
  double get latitude;
  double get longitude;
  
  GeoPoint._();
  factory GeoPoint([void Function(GeoPointBuilder) updates]) = _$GeoPoint;
  
  /// Calculate distance to another GeoPoint in meters
  double distanceTo(GeoPoint other) {
    return DistanceCalculator.calculateDistance(
      lat1: latitude,
      lon1: longitude,
      lat2: other.latitude,
      lon2: other.longitude,
    );
  }
  
  /// Check if this point is within a certain radius of another point
  bool isWithinRadius(GeoPoint center, double radiusInMeters) {
    return DistanceCalculator.isWithinRadius(
      userLat: latitude,
      userLon: longitude,
      targetLat: center.latitude,
      targetLon: center.longitude,
      radius: radiusInMeters,
    );
  }
  
  /// Serialization
  static Serializer<GeoPoint> get serializer => _$geoPointSerializer;
  
  /// From JSON
  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    return GeoPoint((b) => b
      ..latitude = (json['latitude'] as num).toDouble()
      ..longitude = (json['longitude'] as num).toDouble());
  }
  
  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
