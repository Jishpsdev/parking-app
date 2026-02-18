import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/parking_lot.dart';
import '../../domain/repositories/parking_lot_repository.dart';
import '../datasources/parking_remote_datasource.dart';

/// Implementation of ParkingLotRepository
/// Follows Repository Pattern and handles error mapping
class ParkingLotRepositoryImpl implements ParkingLotRepository {
  final ParkingRemoteDataSource _remoteDataSource;
  
  ParkingLotRepositoryImpl({
    required ParkingRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;
  
  @override
  Future<Result<List<ParkingLot>>> getParkingLots() async {
    try {
      final lots = await _remoteDataSource.getParkingLots();
      return Right(lots);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<ParkingLot>> getParkingLotById(String id) async {
    try {
      final lot = await _remoteDataSource.getParkingLotById(id);
      return Right(lot);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Stream<Result<ParkingLot>> watchParkingLot(String id) {
    try {
      return _remoteDataSource.watchParkingLot(id).map(
            (lot) => Right<Failure, ParkingLot>(lot),
          );
    } on ServerException catch (e) {
      return Stream.value(Left(ServerFailure(e.message)));
    } catch (e) {
      return Stream.value(Left(ServerFailure('Unexpected error: $e')));
    }
  }
  
  @override
  Future<Result<List<ParkingLot>>> getNearbyParkingLots({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  }) async {
    try {
      // Get all parking lots
      final lots = await _remoteDataSource.getParkingLots();
      
      // Filter by distance (simple implementation)
      // In production, use Firestore geo queries or dedicated service
      final nearby = lots.where((lot) {
        final distance = lot.location.distanceTo(
          lot.location, // Should be user location
        );
        return distance <= radiusInKm * 1000; // Convert km to meters
      }).toList();
      
      return Right(nearby);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
