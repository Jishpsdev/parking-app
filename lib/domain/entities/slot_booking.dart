import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'slot_status.dart';

part 'slot_booking.g.dart';

/// Domain Entity representing a daily slot booking
/// Each booking is for a specific date
@BuiltValue()
abstract class SlotBooking implements Built<SlotBooking, SlotBookingBuilder> {
  String get id;
  String get slotId;
  String get userId;
  String get parkingLotId;
  
  /// The date this booking is for (date only, no time)
  DateTime get bookingDate;
  
  /// Current status of the booking
  SlotStatus get status;
  
  /// When the slot was reserved
  DateTime get reservedAt;
  
  /// When the slot was physically occupied
  DateTime? get occupiedAt;
  
  /// When the slot was released
  DateTime? get releasedAt;
  
  SlotBooking._();
  factory SlotBooking([void Function(SlotBookingBuilder) updates]) = _$SlotBooking;
  
  /// Serialization
  static Serializer<SlotBooking> get serializer => _$slotBookingSerializer;
  
  /// From Firestore
  factory SlotBooking.fromFirestore(Map<String, dynamic> data, String id) {
    return SlotBooking((b) => b
      ..id = id
      ..slotId = data['slotId'] as String
      ..userId = data['userId'] as String
      ..parkingLotId = data['parkingLotId'] as String
      ..bookingDate = DateTime.parse(data['bookingDate'] as String)
      ..status = SlotStatus.values.firstWhere((e) => e.name == data['status'])
      ..reservedAt = DateTime.parse(data['reservedAt'] as String)
      ..occupiedAt = data['occupiedAt'] != null 
          ? DateTime.parse(data['occupiedAt'] as String)
          : null
      ..releasedAt = data['releasedAt'] != null
          ? DateTime.parse(data['releasedAt'] as String)
          : null);
  }
  
  /// To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'slotId': slotId,
      'userId': userId,
      'parkingLotId': parkingLotId,
      'bookingDate': _dateOnly(bookingDate).toIso8601String(),
      'status': status.name,
      'reservedAt': reservedAt.toIso8601String(),
      'occupiedAt': occupiedAt?.toIso8601String(),
      'releasedAt': releasedAt?.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
  
  /// Helper to get date only (no time component)
  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  /// Check if this booking is for today
  bool get isToday {
    final now = DateTime.now();
    final today = _dateOnly(now);
    final bookingDay = _dateOnly(bookingDate);
    return today.isAtSameMomentAs(bookingDay);
  }
  
  /// Check if booking can be occupied
  bool canBeOccupied() {
    return status == SlotStatus.reserved && isToday;
  }
  
  /// Check if booking can be released
  bool canBeReleased() {
    return (status == SlotStatus.reserved || status == SlotStatus.occupied) && isToday;
  }
}
