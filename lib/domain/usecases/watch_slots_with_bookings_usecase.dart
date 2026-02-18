import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../entities/slot_with_booking.dart';
import '../repositories/booking_repository.dart';
import '../repositories/parking_slot_repository.dart';

/// Use case for watching slots with their current bookings
class WatchSlotsWithBookingsUseCase {
  final ParkingSlotRepository _slotRepository;
  final BookingRepository _bookingRepository;
  
  WatchSlotsWithBookingsUseCase({
    required ParkingSlotRepository slotRepository,
    required BookingRepository bookingRepository,
  })  : _slotRepository = slotRepository,
        _bookingRepository = bookingRepository;
  
  Stream<Result<List<SlotWithBooking>>> call({
    required String parkingLotId,
  }) {
    // Combine two streams: slots and bookings
    return _slotRepository.watchSlots(parkingLotId).asyncMap((slotsResult) async {
      if (slotsResult.isLeft()) {
        return slotsResult.fold(
          (failure) => Left<Failure, List<SlotWithBooking>>(failure),
          (_) => const Left<Failure, List<SlotWithBooking>>(ServerFailure('Unknown error')),
        );
      }
      
      final slots = slotsResult.getOrElse(() => []);
      
      // Get today's bookings
      final bookingsResult = await _bookingRepository.getBookingsByDate(
        parkingLotId: parkingLotId,
        date: DateTime.now(),
      );
      
      if (bookingsResult.isLeft()) {
        // If we can't get bookings, return slots without booking info
        final slotsWithBookings = slots.map((slot) => SlotWithBooking(slot: slot)).toList();
        return Right<Failure, List<SlotWithBooking>>(slotsWithBookings);
      }
      
      final bookings = bookingsResult.getOrElse(() => []);
      
      // Create a map of slotId -> booking for quick lookup
      final bookingMap = {
        for (var booking in bookings) booking.slotId: booking
      };
      
      // Combine slots with their bookings
      final slotsWithBookings = slots.map((slot) {
        final booking = bookingMap[slot.id];
        return SlotWithBooking(
          slot: slot,
          booking: booking,
        );
      }).toList();
      
      return Right<Failure, List<SlotWithBooking>>(slotsWithBookings);
    });
  }
}
