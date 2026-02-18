import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'geo_point.dart';
import 'parking_slot.dart';
import 'vehicle_type.dart';

part 'parking_lot.g.dart';

/// Domain Entity representing a parking lot
/// Aggregate root that contains parking slots
abstract class ParkingLot implements Built<ParkingLot, ParkingLotBuilder> {
  String get id;
  String get name;
  String get address;
  GeoPoint get location;
  double get geofenceRadius;
  BuiltList<ParkingSlot> get slots;
  
  ParkingLot._();
  factory ParkingLot([void Function(ParkingLotBuilder) updates]) = _$ParkingLot;
  
  /// Get available slots by type
  List<ParkingSlot> getAvailableSlotsByType(VehicleType type) {
    return slots
        .where((slot) => slot.type == type && slot.canBeReserved())
        .toList();
  }
  
  /// Get total slots by type
  int getTotalSlotsByType(VehicleType type) {
    return slots.where((slot) => slot.type == type).length;
  }
  
  /// Get available slots count by type
  int getAvailableCountByType(VehicleType type) {
    return getAvailableSlotsByType(type).length;
  }
  
  /// Get occupied slots count by type
  int getOccupiedCountByType(VehicleType type) {
    return slots
        .where((slot) => slot.type == type && slot.status.isOccupied)
        .length;
  }
  
  /// Get reserved slots count by type
  int getReservedCountByType(VehicleType type) {
    return slots
        .where((slot) => slot.type == type && slot.status.isReserved)
        .length;
  }
  
  /// Check if user is within geofence
  bool isUserInRange(GeoPoint userLocation) {
    return userLocation.isWithinRadius(location, geofenceRadius);
  }
  
  /// Get slot by id
  ParkingSlot? getSlotById(String slotId) {
    try {
      return slots.firstWhere((slot) => slot.id == slotId);
    } catch (e) {
      return null;
    }
  }
  
  /// Get all slots by type
  List<ParkingSlot> getSlotsByType(VehicleType type) {
    return slots.where((slot) => slot.type == type).toList();
  }
  
  /// Serialization
  static Serializer<ParkingLot> get serializer => _$parkingLotSerializer;
  
  /// From Firestore
  factory ParkingLot.fromFirestore(
    Map<String, dynamic> data,
    String id, {
    List<ParkingSlot>? slotsList,
  }) {
    return ParkingLot((b) => b
      ..id = id
      ..name = data['name'] as String
      ..address = data['address'] as String
      ..location = GeoPoint.fromJson(data['location'] as Map<String, dynamic>).toBuilder()
      ..geofenceRadius = (data['geofenceRadius'] as num).toDouble()
      ..slots = ListBuilder<ParkingSlot>(slotsList ?? []));
  }
  
  /// To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'location': location.toJson(),
      'geofenceRadius': geofenceRadius,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
