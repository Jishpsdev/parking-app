import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../entities/geo_point.dart';
import '../entities/parking_lot.dart';
import '../entities/slot_booking.dart';
import '../repositories/booking_repository.dart';
import '../repositories/location_repository.dart';
import '../repositories/parking_lot_repository.dart';
import '../repositories/user_repository.dart';

/// Use Case for reserving a parking slot
/// Follows Single Responsibility Principle
/// Encapsulates business logic with location verification and date-based bookings
class ReserveSlotUseCase {
  final BookingRepository _bookingRepository;
  final ParkingLotRepository _lotRepository;
  final LocationRepository _locationRepository;
  final UserRepository _userRepository;
  
  ReserveSlotUseCase({
    required BookingRepository bookingRepository,
    required ParkingLotRepository lotRepository,
    required LocationRepository locationRepository,
    required UserRepository userRepository,
  })  : _bookingRepository = bookingRepository,
        _lotRepository = lotRepository,
        _locationRepository = locationRepository,
        _userRepository = userRepository;
  
  /// Execute the use case
  /// Returns Result with the created booking or failure
  Future<Result<SlotBooking>> call({
    required String parkingLotId,
    required String slotId,
    required String userId,
  }) async {
    // Step 1: Get user details to check permissions
    final userResult = await _userRepository.getCurrentUser();
    if (userResult.isLeft()) {
      return userResult.fold(
        (failure) => Left(failure),
        (_) => const Left(ServerFailure('Failed to get user details')),
      );
    }
    
    final user = userResult.getOrThrow();
    
    // Step 2: Check if user already has a booking for today
    final today = DateTime.now();
    final existingBookingResult = await _bookingRepository.getUserBookingForDate(
      userId: userId,
      date: today,
    );
    
    if (existingBookingResult.isRight()) {
      final existingBooking = existingBookingResult.getOrElse(() => null);
      if (existingBooking != null) {
        return const Left(
          ServerFailure('You already have a booking for today. You can only book one slot per day.'),
        );
      }
    }
    
    // Step 3: Get parking lot details
    final lotResult = await _lotRepository.getParkingLotById(parkingLotId);
    if (lotResult.isLeft()) {
      return lotResult.fold(
        (failure) => Left(failure),
        (_) => const Left(ServerFailure('Failed to get parking lot')),
      );
    }
    
    final ParkingLot parkingLot = lotResult.getOrThrow();
    
    // Step 4: Get user's current location
    final locationResult = await _locationRepository.getCurrentLocation();
    if (locationResult.isLeft()) {
      return locationResult.fold(
        (failure) => Left(failure),
        (_) => const Left(LocationFailure('Failed to get current location')),
      );
    }
    
    final GeoPoint userLocation = locationResult.getOrThrow();
    
    // Step 5: Verify user is within geofence
    final bool isInRange = parkingLot.isUserInRange(userLocation);
    
    // Step 6: Check user permissions
    // Admin users can reserve remotely, Regular users must be on-site
    if (!user.canReserveRemotely && !isInRange) {
      return const Left(
        UserNotInRangeFailure(
          'Regular users can only book slots when physically present at the parking location',
        ),
      );
    }
    
    // Admin users can reserve from anywhere, but still log if they're not in range
    if (user.canReserveRemotely && !isInRange) {
      // Admin user reserving remotely - allowed
      // Could add logging here for analytics
    }
    
    // Step 7: Create the booking
    final bookingResult = await _bookingRepository.createBooking(
      slotId: slotId,
      userId: userId,
      parkingLotId: parkingLotId,
      bookingDate: today,
    );
    
    if (bookingResult.isLeft()) {
      return bookingResult;
    }
    
    // Step 8: Update user's active reservation
    final booking = bookingResult.getOrThrow();
    await _userRepository.updateActiveReservation(
      userId: userId,
      reservationId: booking.id,
    );
    
    return bookingResult;
  }
}
