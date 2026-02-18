import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'slot_status.dart';
import 'vehicle_type.dart';

part 'parking_slot.g.dart';

/// Domain Entity representing a parking slot
/// Immutable entity with business rules
abstract class ParkingSlot implements Built<ParkingSlot, ParkingSlotBuilder> {
  String get id;
  String get slotNumber;
  VehicleType get type;
  SlotStatus get status;
  
  /// Floor number (e.g., "4th floor" would be 4)
  int get floor;
  
  /// Wing identifier (e.g., "A", "B", "C")
  String get wing;
  
  @BuiltValueField(wireName: 'reservedBy')
  String? get reservedBy;
  
  @BuiltValueField(wireName: 'reservedAt')
  DateTime? get reservedAt;
  
  @BuiltValueField(wireName: 'occupiedAt')
  DateTime? get occupiedAt;
  
  ParkingSlot._();
  factory ParkingSlot([void Function(ParkingSlotBuilder) updates]) = _$ParkingSlot;
  
  /// Business rule: Check if slot can be reserved
  bool canBeReserved() {
    return status == SlotStatus.available;
  }
  
  /// Business rule: Check if slot can be occupied
  bool canBeOccupied(String userId) {
    return status == SlotStatus.reserved && reservedBy == userId;
  }
  
  /// Business rule: Check if slot can be released
  bool canBeReleased(String userId) {
    return (status == SlotStatus.reserved || status == SlotStatus.occupied) &&
           reservedBy == userId;
  }
  
  /// Business rule: Check if reservation has expired
  bool isReservationExpired(Duration timeout) {
    if (status != SlotStatus.reserved || reservedAt == null) {
      return false;
    }
    return DateTime.now().difference(reservedAt!) > timeout;
  }
  
  /// Serialization
  static Serializer<ParkingSlot> get serializer => _$parkingSlotSerializer;
  
  /// From Firestore
  factory ParkingSlot.fromFirestore(Map<String, dynamic> data, String id) {
    return ParkingSlot((b) => b
      ..id = id
      ..slotNumber = data['slotNumber'] as String
      ..type = VehicleType.values.firstWhere((e) => e.name == data['type'])
      ..status = SlotStatus.values.firstWhere((e) => e.name == data['status'])
      ..floor = data['floor'] as int
      ..wing = data['wing'] as String
      ..reservedBy = data['reservedBy'] as String?
      ..reservedAt = data['reservedAt'] != null 
          ? DateTime.parse(data['reservedAt'] as String)
          : null
      ..occupiedAt = data['occupiedAt'] != null
          ? DateTime.parse(data['occupiedAt'] as String)
          : null);
  }
  
  /// To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'slotNumber': slotNumber,
      'type': type.name,
      'status': status.name,
      'floor': floor,
      'wing': wing,
      'reservedBy': reservedBy,
      'reservedAt': reservedAt?.toIso8601String(),
      'occupiedAt': occupiedAt?.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
  
  /// Get formatted floor display (e.g., "4th floor")
  String get floorDisplay {
    final suffix = _getOrdinalSuffix(floor);
    return '$floor$suffix floor';
  }
  
  /// Get formatted location (e.g., "4th floor, Wing A")
  String get locationDisplay {
    return '$floorDisplay, Wing $wing';
  }
  
  String _getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) return 'th';
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
