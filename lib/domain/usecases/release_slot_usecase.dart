import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../repositories/booking_repository.dart';
import '../repositories/user_repository.dart';

/// Use Case for releasing a parking slot booking
/// Can release both reserved and occupied bookings
class ReleaseSlotUseCase {
  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;
  
  ReleaseSlotUseCase({
    required BookingRepository bookingRepository,
    required UserRepository userRepository,
  })  : _bookingRepository = bookingRepository,
        _userRepository = userRepository;
  
  Future<Result<void>> call({
    required String bookingId,
    required String userId,
  }) async {
    // Step 1: Get current booking
    final bookingResult = await _bookingRepository.getBookingById(bookingId);
    if (bookingResult.isLeft()) {
      return bookingResult.fold(
        (failure) => Left(failure),
        (_) => const Left(ServerFailure('Failed to get booking')),
      );
    }
    
    final booking = bookingResult.getOrThrow();
    
    // Step 2: Verify user owns this booking
    if (booking.userId != userId) {
      return const Left(
        ValidationFailure('You can only release your own booking'),
      );
    }
    
    // Step 3: Verify booking can be released
    if (!booking.canBeReleased()) {
      return const Left(
        ValidationFailure('This booking cannot be released'),
      );
    }
    
    // Step 4: Release the booking
    final releaseResult = await _bookingRepository.releaseBooking(
      bookingId: bookingId,
    );
    
    if (releaseResult.isRight()) {
      // Step 5: Clear user's active reservation
      await _userRepository.updateActiveReservation(
        userId: userId,
        reservationId: null,
      );
    }
    
    return releaseResult;
  }
}
