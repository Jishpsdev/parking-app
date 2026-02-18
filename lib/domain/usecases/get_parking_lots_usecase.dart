import '../../core/utils/result.dart';
import '../entities/parking_lot.dart';
import '../repositories/parking_lot_repository.dart';

/// Use Case for getting all parking lots
class GetParkingLotsUseCase {
  final ParkingLotRepository _repository;
  
  GetParkingLotsUseCase({
    required ParkingLotRepository repository,
  }) : _repository = repository;
  
  Future<Result<List<ParkingLot>>> call() async {
    return await _repository.getParkingLots();
  }
}
