import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../entities/slot_booking.dart';
import '../repositories/booking_repository.dart';

/// Use Case for occupying a reserved parking slot
/// User must have the slot reserved before occupying
class OccupySlotUseCase {
  final BookingRepository _bookingRepository;
  
  OccupySlotUseCase({
    required BookingRepository bookingRepository,
  }) : _bookingRepository = bookingRepository;
  
  Future<Result<SlotBooking>> call({
    required String bookingId,
  }) async {
    // Step 1: Get current booking
    final bookingResult = await _bookingRepository.getBookingById(bookingId);
    if (bookingResult.isLeft()) {
      return bookingResult.fold(
        (failure) => Left(failure),
        (_) => const Left(ServerFailure('Failed to get booking')),
      );
    }
    
    final SlotBooking booking = bookingResult.getOrThrow();
    
    // Step 2: Verify booking can be occupied
    if (!booking.canBeOccupied()) {
      return const Left(
        ValidationFailure('This booking cannot be occupied'),
      );
    }
    
    // Step 3: Occupy the booking
    return await _bookingRepository.occupyBooking(
      bookingId: bookingId,
    );
  }
}
