/// Enum representing parking slot status
/// Part of State Pattern implementation
enum SlotStatus {
  available,
  reserved,
  occupied;
  
  String get displayName {
    switch (this) {
      case SlotStatus.available:
        return 'Available';
      case SlotStatus.reserved:
        return 'Reserved';
      case SlotStatus.occupied:
        return 'Occupied';
    }
  }
  
  /// Check if transition to new status is valid
  /// Implements state machine logic
  bool canTransitionTo(SlotStatus newStatus) {
    switch (this) {
      case SlotStatus.available:
        return newStatus == SlotStatus.reserved;
      case SlotStatus.reserved:
        return newStatus == SlotStatus.occupied || 
               newStatus == SlotStatus.available;
      case SlotStatus.occupied:
        return newStatus == SlotStatus.available;
    }
  }
  
  bool get isAvailable => this == SlotStatus.available;
  bool get isReserved => this == SlotStatus.reserved;
  bool get isOccupied => this == SlotStatus.occupied;
}
