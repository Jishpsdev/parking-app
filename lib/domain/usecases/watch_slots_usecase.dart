import '../../core/utils/result.dart';
import '../entities/parking_slot.dart';
import '../repositories/parking_slot_repository.dart';

/// Use Case for watching real-time slot changes
/// Implements Observer Pattern through streams
class WatchSlotsUseCase {
  final ParkingSlotRepository _repository;
  
  WatchSlotsUseCase({
    required ParkingSlotRepository repository,
  }) : _repository = repository;
  
  Stream<Result<List<ParkingSlot>>> call(String parkingLotId) {
    return _repository.watchSlots(parkingLotId);
  }
}
