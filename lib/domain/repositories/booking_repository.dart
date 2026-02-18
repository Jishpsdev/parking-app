import '../../core/utils/result.dart';
import '../entities/slot_booking.dart';

/// Repository interface for Slot Bookings
abstract class BookingRepository {
  /// Get all bookings for a specific date
  Future<Result<List<SlotBooking>>> getBookingsByDate({
    required String parkingLotId,
    required DateTime date,
  });
  
  /// Get user's booking for a specific date
  Future<Result<SlotBooking?>> getUserBookingForDate({
    required String userId,
    required DateTime date,
  });
  
  /// Create a new booking (reserve slot)
  Future<Result<SlotBooking>> createBooking({
    required String slotId,
    required String userId,
    required String parkingLotId,
    required DateTime bookingDate,
  });
  
  /// Update booking status (occupy)
  Future<Result<SlotBooking>> occupyBooking({
    required String bookingId,
  });
  
  /// Release booking
  Future<Result<void>> releaseBooking({
    required String bookingId,
  });
  
  /// Watch today's bookings (real-time)
  Stream<Result<List<SlotBooking>>> watchTodayBookings({
    required String parkingLotId,
  });
  
  /// Get booking by ID
  Future<Result<SlotBooking>> getBookingById(String bookingId);
}
