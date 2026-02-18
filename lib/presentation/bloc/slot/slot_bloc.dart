import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/usecases/occupy_slot_usecase.dart';
import '../../../domain/usecases/release_slot_usecase.dart';
import '../../../domain/usecases/reserve_slot_usecase.dart';
import '../../../domain/usecases/watch_slots_with_bookings_usecase.dart';
import 'slot_event.dart';
import 'slot_state.dart';

/// Action message for user feedback
class SlotActionMessage {
  final SlotActionStatus status;
  final String message;
  
  const SlotActionMessage({
    required this.status,
    required this.message,
  });
}

/// BLoC for managing slot state with real-time updates
/// Implements Observer Pattern through stream subscriptions
/// Action feedback is separate from slot data
class SlotBloc extends Bloc<SlotEvent, SlotState> {
  final WatchSlotsWithBookingsUseCase _watchSlotsWithBookingsUseCase;
  final ReserveSlotUseCase _reserveSlotUseCase;
  final OccupySlotUseCase _occupySlotUseCase;
  final ReleaseSlotUseCase _releaseSlotUseCase;
  
  /// Separate stream for action feedback (like RxDart PublishSubject)
  /// This doesn't interfere with the main slot data stream
  final _actionMessageController = StreamController<SlotActionMessage>.broadcast();
  Stream<SlotActionMessage> get actionMessages => _actionMessageController.stream;
  
  SlotBloc({
    required WatchSlotsWithBookingsUseCase watchSlotsWithBookingsUseCase,
    required ReserveSlotUseCase reserveSlotUseCase,
    required OccupySlotUseCase occupySlotUseCase,
    required ReleaseSlotUseCase releaseSlotUseCase,
  })  : _watchSlotsWithBookingsUseCase = watchSlotsWithBookingsUseCase,
        _reserveSlotUseCase = reserveSlotUseCase,
        _occupySlotUseCase = occupySlotUseCase,
        _releaseSlotUseCase = releaseSlotUseCase,
        super(const SlotInitial()) {
    on<WatchSlotsEvent>(_onWatchSlots);
    on<ReserveSlotEvent>(_onReserveSlot);
    on<OccupySlotEvent>(_onOccupySlot);
    on<ReleaseSlotEvent>(_onReleaseSlot);
  }
  
  @override
  Future<void> close() {
    _actionMessageController.close();
    return super.close();
  }
  
  Future<void> _onWatchSlots(
    WatchSlotsEvent event,
    Emitter<SlotState> emit,
  ) async {
    emit(const SlotLoading());
    
    // Use emit.forEach to properly handle the stream
    await emit.forEach<dynamic>(
      _watchSlotsWithBookingsUseCase(parkingLotId: event.parkingLotId),
      onData: (result) {
        return result.fold(
          (failure) => SlotError(message: failure.message),
          (slotsWithBookings) => SlotLoaded(slotsWithBookings),
        );
      },
    );
  }
  
  Future<void> _onReserveSlot(
    ReserveSlotEvent event,
    Emitter<SlotState> emit,
  ) async {
    // Send progress message via separate stream
    _actionMessageController.add(
      const SlotActionMessage(
        status: SlotActionStatus.inProgress,
        message: 'Reserving slot...',
      ),
    );
    
    final result = await _reserveSlotUseCase(
      parkingLotId: event.parkingLotId,
      slotId: event.slotId,
      userId: event.userId,
    );
    
    // Send result message via separate stream
    // Firestore stream will automatically update slot data
    result.fold(
      (failure) => _actionMessageController.add(
        SlotActionMessage(
          status: SlotActionStatus.error,
          message: failure.message,
        ),
      ),
      (slot) => _actionMessageController.add(
        const SlotActionMessage(
          status: SlotActionStatus.success,
          message: AppConstants.slotReservedSuccess,
        ),
      ),
    );
  }
  
  Future<void> _onOccupySlot(
    OccupySlotEvent event,
    Emitter<SlotState> emit,
  ) async {
    // Send progress message via separate stream
    _actionMessageController.add(
      const SlotActionMessage(
        status: SlotActionStatus.inProgress,
        message: 'Marking slot as occupied...',
      ),
    );
    
    final result = await _occupySlotUseCase(
      bookingId: event.bookingId,
    );
    
    // Send result message via separate stream
    result.fold(
      (failure) => _actionMessageController.add(
        SlotActionMessage(
          status: SlotActionStatus.error,
          message: failure.message,
        ),
      ),
      (booking) => _actionMessageController.add(
        const SlotActionMessage(
          status: SlotActionStatus.success,
          message: AppConstants.slotOccupiedSuccess,
        ),
      ),
    );
  }
  
  Future<void> _onReleaseSlot(
    ReleaseSlotEvent event,
    Emitter<SlotState> emit,
  ) async {
    // Send progress message via separate stream
    _actionMessageController.add(
      const SlotActionMessage(
        status: SlotActionStatus.inProgress,
        message: 'Releasing slot...',
      ),
    );
    
    final result = await _releaseSlotUseCase(
      bookingId: event.bookingId,
      userId: event.userId,
    );
    
    // Send result message via separate stream
    result.fold(
      (failure) => _actionMessageController.add(
        SlotActionMessage(
          status: SlotActionStatus.error,
          message: failure.message,
        ),
      ),
      (_) => _actionMessageController.add(
        const SlotActionMessage(
          status: SlotActionStatus.success,
          message: AppConstants.slotReleasedSuccess,
        ),
      ),
    );
  }
}
