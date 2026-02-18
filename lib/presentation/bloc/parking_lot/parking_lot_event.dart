/// Events for ParkingLot BLoC
abstract class ParkingLotEvent {
  const ParkingLotEvent();
}

/// Load all parking lots
class LoadParkingLotsEvent extends ParkingLotEvent {
  const LoadParkingLotsEvent();
}

/// Select a parking lot
class SelectParkingLotEvent extends ParkingLotEvent {
  final String parkingLotId;
  
  const SelectParkingLotEvent(this.parkingLotId);
}
