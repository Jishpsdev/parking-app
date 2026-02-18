import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/parking_slot.dart';
import '../../domain/entities/slot_status.dart';
import '../../domain/entities/vehicle_type.dart';
import '../../domain/repositories/parking_slot_repository.dart';
import '../datasources/parking_remote_datasource.dart';

/// Implementation of ParkingSlotRepository
class ParkingSlotRepositoryImpl implements ParkingSlotRepository {
  final ParkingRemoteDataSource _remoteDataSource;
  
  ParkingSlotRepositoryImpl({
    required ParkingRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;
  
  @override
  Future<Result<List<ParkingSlot>>> getSlots(String parkingLotId) async {
    try {
      final slots = await _remoteDataSource.getSlots(parkingLotId);
      return Right(slots);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<ParkingSlot>> getSlotById(
    String parkingLotId,
    String slotId,
  ) async {
    try {
      final slot = await _remoteDataSource.getSlotById(parkingLotId, slotId);
      return Right(slot);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Stream<Result<List<ParkingSlot>>> watchSlots(String parkingLotId) {
    try {
      return _remoteDataSource.watchSlots(parkingLotId).map(
            (slots) => Right<Failure, List<ParkingSlot>>(slots),
          );
    } on ServerException catch (e) {
      return Stream.value(Left(ServerFailure(e.message)));
    } catch (e) {
      return Stream.value(Left(ServerFailure('Unexpected error: $e')));
    }
  }
  
  @override
  Future<Result<void>> updateSlotStatus({
    required String parkingLotId,
    required String slotId,
    required SlotStatus status,
    String? userId,
  }) async {
    try {
      final data = {
        'status': status.name,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      if (userId != null) {
        data['reservedBy'] = userId;
      }
      
      await _remoteDataSource.updateSlot(parkingLotId, slotId, data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<ParkingSlot>> reserveSlot({
    required String parkingLotId,
    required String slotId,
    required String userId,
  }) async {
    try {
      final data = {
        'status': SlotStatus.reserved.name,
        'reservedBy': userId,
        'reservedAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      await _remoteDataSource.updateSlot(parkingLotId, slotId, data);
      
      // Get updated slot
      final slot = await _remoteDataSource.getSlotById(parkingLotId, slotId);
      return Right(slot);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<ParkingSlot>> occupySlot({
    required String parkingLotId,
    required String slotId,
    required String userId,
  }) async {
    try {
      final data = {
        'status': SlotStatus.occupied.name,
        'occupiedAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      await _remoteDataSource.updateSlot(parkingLotId, slotId, data);
      
      // Get updated slot
      final slot = await _remoteDataSource.getSlotById(parkingLotId, slotId);
      return Right(slot);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<ParkingSlot>> releaseSlot({
    required String parkingLotId,
    required String slotId,
    required String userId,
  }) async {
    try {
      final data = {
        'status': SlotStatus.available.name,
        'reservedBy': null,
        'reservedAt': null,
        'occupiedAt': null,
        'updatedAt': DateTime.now().toIso8601String(),
      };
      
      await _remoteDataSource.updateSlot(parkingLotId, slotId, data);
      
      // Get updated slot
      final slot = await _remoteDataSource.getSlotById(parkingLotId, slotId);
      return Right(slot);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<List<ParkingSlot>>> getAvailableSlotsByType({
    required String parkingLotId,
    required VehicleType type,
  }) async {
    try {
      final slots = await _remoteDataSource.getSlots(parkingLotId);
      
      final availableSlots = slots
          .where((slot) =>
              slot.type == type && slot.status == SlotStatus.available)
          .toList();
      
      return Right(availableSlots);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
