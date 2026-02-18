import '../../../domain/entities/slot_with_booking.dart';

/// Status for slot actions (reserve, occupy, release)
/// Separate from main slot data
enum SlotActionStatus {
  idle,
  inProgress,
  success,
  error,
}

/// States for Slot BLoC
abstract class SlotState {
  const SlotState();
}

/// Initial state
class SlotInitial extends SlotState {
  const SlotInitial();
}

/// Loading state (initial load only)
class SlotLoading extends SlotState {
  const SlotLoading();
}

/// Loaded state (with real-time updates)
/// This is the ONLY state that carries slots with their bookings
/// Action status is tracked separately and doesn't affect slot display
class SlotLoaded extends SlotState {
  final List<SlotWithBooking> slots;
  final SlotActionStatus actionStatus;
  final String? actionMessage;
  
  const SlotLoaded(
    this.slots, {
    this.actionStatus = SlotActionStatus.idle,
    this.actionMessage,
  });
  
  /// Copy with updated action status
  SlotLoaded copyWith({
    List<SlotWithBooking>? slots,
    SlotActionStatus? actionStatus,
    String? actionMessage,
  }) {
    return SlotLoaded(
      slots ?? this.slots,
      actionStatus: actionStatus ?? this.actionStatus,
      actionMessage: actionMessage ?? this.actionMessage,
    );
  }
}

/// Error state (only for stream errors, not action errors)
class SlotError extends SlotState {
  final String message;
  
  const SlotError({
    required this.message,
  });
}
