import '../../core/utils/result.dart';
import '../entities/parking_lot.dart';

/// Repository interface for ParkingLot
/// Follows Dependency Inversion Principle (depends on abstraction)
/// Follows Interface Segregation Principle (specific interface)
abstract class ParkingLotRepository {
  /// Get all parking lots
  Future<Result<List<ParkingLot>>> getParkingLots();
  
  /// Get parking lot by id
  Future<Result<ParkingLot>> getParkingLotById(String id);
  
  /// Watch parking lot changes (real-time)
  Stream<Result<ParkingLot>> watchParkingLot(String id);
  
  /// Get nearby parking lots
  Future<Result<List<ParkingLot>>> getNearbyParkingLots({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  });
}
