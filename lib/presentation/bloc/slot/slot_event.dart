/// Events for Slot BLoC
abstract class SlotEvent {
  const SlotEvent();
}

/// Watch slots for a parking lot (real-time)
class WatchSlotsEvent extends SlotEvent {
  final String parkingLotId;
  
  const WatchSlotsEvent(this.parkingLotId);
}

/// Reserve a slot
class ReserveSlotEvent extends SlotEvent {
  final String parkingLotId;
  final String slotId;
  final String userId;
  
  const ReserveSlotEvent({
    required this.parkingLotId,
    required this.slotId,
    required this.userId,
  });
}

/// Occupy a reserved slot
class OccupySlotEvent extends SlotEvent {
  final String bookingId;
  
  const OccupySlotEvent({
    required this.bookingId,
  });
}

/// Release a slot
class ReleaseSlotEvent extends SlotEvent {
  final String bookingId;
  final String userId;
  
  const ReleaseSlotEvent({
    required this.bookingId,
    required this.userId,
  });
}
