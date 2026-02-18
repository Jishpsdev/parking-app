import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/distance_calculator.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/geo_point.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_datasource.dart';

/// Implementation of LocationRepository
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource _dataSource;
  
  LocationRepositoryImpl({
    required LocationDataSource dataSource,
  }) : _dataSource = dataSource;
  
  @override
  Future<Result<GeoPoint>> getCurrentLocation() async {
    try {
      final location = await _dataSource.getCurrentLocation();
      return Right(location);
    } on LocationException catch (e) {
      return Left(LocationFailure(e.message));
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.message));
    } catch (e) {
      return Left(LocationFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<bool>> isLocationServiceEnabled() async {
    try {
      final enabled = await _dataSource.isLocationServiceEnabled();
      return Right(enabled);
    } on LocationException catch (e) {
      return Left(LocationFailure(e.message));
    } catch (e) {
      return Left(LocationFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<bool>> requestLocationPermission() async {
    try {
      final granted = await _dataSource.requestLocationPermission();
      return Right(granted);
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.message));
    } catch (e) {
      return Left(PermissionFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Future<Result<bool>> hasLocationPermission() async {
    try {
      final hasPermission = await _dataSource.hasLocationPermission();
      return Right(hasPermission);
    } on PermissionException catch (e) {
      return Left(PermissionFailure(e.message));
    } catch (e) {
      return Left(PermissionFailure('Unexpected error: $e'));
    }
  }
  
  @override
  Stream<Result<GeoPoint>> watchLocation() {
    try {
      return _dataSource.watchLocation().map(
            (location) => Right<Failure, GeoPoint>(location),
          );
    } on LocationException catch (e) {
      return Stream.value(Left(LocationFailure(e.message)));
    } catch (e) {
      return Stream.value(Left(LocationFailure('Unexpected error: $e')));
    }
  }
  
  @override
  double calculateDistance(GeoPoint from, GeoPoint to) {
    return DistanceCalculator.calculateDistance(
      lat1: from.latitude,
      lon1: from.longitude,
      lat2: to.latitude,
      lon2: to.longitude,
    );
  }
  
  @override
  bool isWithinRadius({
    required GeoPoint userLocation,
    required GeoPoint targetLocation,
    required double radiusInMeters,
  }) {
    return DistanceCalculator.isWithinRadius(
      userLat: userLocation.latitude,
      userLon: userLocation.longitude,
      targetLat: targetLocation.latitude,
      targetLon: targetLocation.longitude,
      radius: radiusInMeters,
    );
  }
}
