import '../../core/utils/result.dart';
import '../entities/parking_slot.dart';
import '../entities/slot_status.dart';
import '../entities/vehicle_type.dart';

/// Repository interface for ParkingSlot
/// Follows Repository Pattern and Dependency Inversion Principle
abstract class ParkingSlotRepository {
  /// Get all slots for a parking lot
  Future<Result<List<ParkingSlot>>> getSlots(String parkingLotId);
  
  /// Get slot by id
  Future<Result<ParkingSlot>> getSlotById(String parkingLotId, String slotId);
  
  /// Watch slots changes (real-time)
  Stream<Result<List<ParkingSlot>>> watchSlots(String parkingLotId);
  
  /// Update slot status
  Future<Result<void>> updateSlotStatus({
    required String parkingLotId,
    required String slotId,
    required SlotStatus status,
    String? userId,
  });
  
  /// Reserve a slot
  Future<Result<ParkingSlot>> reserveSlot({
    required String parkingLotId,
    required String slotId,
    required String userId,
  });
  
  /// Occupy a slot
  Future<Result<ParkingSlot>> occupySlot({
    required String parkingLotId,
    required String slotId,
    required String userId,
  });
  
  /// Release a slot
  Future<Result<ParkingSlot>> releaseSlot({
    required String parkingLotId,
    required String slotId,
    required String userId,
  });
  
  /// Get available slots by type
  Future<Result<List<ParkingSlot>>> getAvailableSlotsByType({
    required String parkingLotId,
    required VehicleType type,
  });
}
