import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_parking_lots_usecase.dart';
import 'parking_lot_event.dart';
import 'parking_lot_state.dart';

/// BLoC for managing parking lot state
/// Follows BLoC pattern for separation of concerns
class ParkingLotBloc extends Bloc<ParkingLotEvent, ParkingLotState> {
  final GetParkingLotsUseCase _getParkingLotsUseCase;
  
  ParkingLotBloc({
    required GetParkingLotsUseCase getParkingLotsUseCase,
  })  : _getParkingLotsUseCase = getParkingLotsUseCase,
        super(const ParkingLotInitial()) {
    on<LoadParkingLotsEvent>(_onLoadParkingLots);
    on<SelectParkingLotEvent>(_onSelectParkingLot);
  }
  
  Future<void> _onLoadParkingLots(
    LoadParkingLotsEvent event,
    Emitter<ParkingLotState> emit,
  ) async {
    emit(const ParkingLotLoading());
    
    final result = await _getParkingLotsUseCase();
    
    result.fold(
      (failure) => emit(ParkingLotError(failure.message)),
      (parkingLots) => emit(ParkingLotLoaded(parkingLots: parkingLots)),
    );
  }
  
  Future<void> _onSelectParkingLot(
    SelectParkingLotEvent event,
    Emitter<ParkingLotState> emit,
  ) async {
    if (state is ParkingLotLoaded) {
      final currentState = state as ParkingLotLoaded;
      
      final selectedLot = currentState.parkingLots.firstWhere(
        (lot) => lot.id == event.parkingLotId,
      );
      
      emit(currentState.copyWith(selectedParkingLot: selectedLot));
    }
  }
}
