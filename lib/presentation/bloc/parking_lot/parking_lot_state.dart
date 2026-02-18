import '../../../domain/entities/parking_lot.dart';

/// States for ParkingLot BLoC
abstract class ParkingLotState {
  const ParkingLotState();
}

/// Initial state
class ParkingLotInitial extends ParkingLotState {
  const ParkingLotInitial();
}

/// Loading state
class ParkingLotLoading extends ParkingLotState {
  const ParkingLotLoading();
}

/// Loaded state
class ParkingLotLoaded extends ParkingLotState {
  final List<ParkingLot> parkingLots;
  final ParkingLot? selectedParkingLot;
  
  const ParkingLotLoaded({
    required this.parkingLots,
    this.selectedParkingLot,
  });
  
  ParkingLotLoaded copyWith({
    List<ParkingLot>? parkingLots,
    ParkingLot? selectedParkingLot,
  }) {
    return ParkingLotLoaded(
      parkingLots: parkingLots ?? this.parkingLots,
      selectedParkingLot: selectedParkingLot ?? this.selectedParkingLot,
    );
  }
}

/// Error state
class ParkingLotError extends ParkingLotState {
  final String message;
  
  const ParkingLotError(this.message);
}
