import 'parking_slot.dart';
import 'slot_booking.dart';
import 'slot_status.dart';

/// Combined entity representing a parking slot with its current booking (if any)
class SlotWithBooking {
  final ParkingSlot slot;
  final SlotBooking? booking;
  
  const SlotWithBooking({
    required this.slot,
    this.booking,
  });
  
  /// Get the current status (from booking if exists, otherwise available)
  SlotStatus get status {
    if (booking != null && (booking!.status == SlotStatus.reserved || booking!.status == SlotStatus.occupied)) {
      return booking!.status;
    }
    return SlotStatus.available;
  }
  
  /// Get the user who booked this slot (if any)
  String? get bookedBy => booking?.userId;
  
  /// Check if slot can be reserved (available and no booking for today)
  bool canBeReserved() {
    return booking == null || booking!.status == SlotStatus.available;
  }
  
  /// Check if slot can be occupied by user
  bool canBeOccupied(String userId) {
    return booking != null && 
           booking!.userId == userId && 
           booking!.status == SlotStatus.reserved &&
           booking!.isToday;
  }
  
  /// Check if slot can be released by user
  bool canBeReleased(String userId) {
    return booking != null &&
           booking!.userId == userId &&
           (booking!.status == SlotStatus.reserved || booking!.status == SlotStatus.occupied) &&
           booking!.isToday;
  }
  
  /// Get booking ID if exists
  String? get bookingId => booking?.id;
  
  /// Get reserved/occupied time
  DateTime? get reservedAt => booking?.reservedAt;
  DateTime? get occupiedAt => booking?.occupiedAt;
  
  /// Copy with
  SlotWithBooking copyWith({
    ParkingSlot? slot,
    SlotBooking? booking,
  }) {
    return SlotWithBooking(
      slot: slot ?? this.slot,
      booking: booking ?? this.booking,
    );
  }
}
