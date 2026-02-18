import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/slot_booking.dart';
import '../../domain/entities/slot_status.dart';
import '../../domain/repositories/booking_repository.dart';

/// Implementation of BookingRepository
class BookingRepositoryImpl implements BookingRepository {
  final FirebaseFirestore _firestore;
  
  BookingRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;
  
  /// Helper to get date only (no time component)
  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  @override
  Future<Result<List<SlotBooking>>> getBookingsByDate({
    required String parkingLotId,
    required DateTime date,
  }) async {
    try {
      final dateOnly = _dateOnly(date);
      final dateStr = dateOnly.toIso8601String();
      
      final querySnapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('parkingLotId', isEqualTo: parkingLotId)
          .where('bookingDate', isEqualTo: dateStr)
          .get();
      
      final bookings = querySnapshot.docs
          .map((doc) => SlotBooking.fromFirestore(doc.data(), doc.id))
          .toList();
      
      return Right(bookings);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get bookings: $e'));
    }
  }
  
  @override
  Future<Result<SlotBooking?>> getUserBookingForDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateOnly = _dateOnly(date);
      final dateStr = dateOnly.toIso8601String();
      
      final querySnapshot = await _firestore
          .collection(AppConstants.bookingsCollection)
          .where('userId', isEqualTo: userId)
          .where('bookingDate', isEqualTo: dateStr)
          .where('status', whereIn: ['reserved', 'occupied'])
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        return const Right(null);
      }
      
      final booking = SlotBooking.fromFirestore(
        querySnapshot.docs.first.data(),
        querySnapshot.docs.first.id,
      );
      
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get user booking: $e'));
    }
  }
  
  @override
  Future<Result<SlotBooking>> createBooking({
    required String slotId,
    required String userId,
    required String parkingLotId,
    required DateTime bookingDate,
  }) async {
    try {
      final dateOnly = _dateOnly(bookingDate);
      
      // Check if user already has a booking for this date
      final existingBooking = await getUserBookingForDate(
        userId: userId,
        date: dateOnly,
      );
      
      if (existingBooking.isRight()) {
        final booking = existingBooking.getOrElse(() => null);
        if (booking != null) {
          return const Left(ServerFailure('You already have a booking for this date'));
        }
      }
      
      // Check if slot is already booked for this date
      final existingSlotBookings = await getBookingsByDate(
        parkingLotId: parkingLotId,
        date: dateOnly,
      );
      
      if (existingSlotBookings.isRight()) {
        final bookings = existingSlotBookings.getOrElse(() => []);
        final hasBooking = bookings.any((b) => 
          b.slotId == slotId && 
          (b.status == SlotStatus.reserved || b.status == SlotStatus.occupied)
        );
        
        if (hasBooking) {
          return const Left(ServerFailure('This slot is already booked for today'));
        }
      }
      
      // Create new booking
      final now = DateTime.now();
      final booking = SlotBooking((b) => b
        ..id = ''
        ..slotId = slotId
        ..userId = userId
        ..parkingLotId = parkingLotId
        ..bookingDate = dateOnly
        ..status = SlotStatus.reserved
        ..reservedAt = now);
      
      final docRef = await _firestore
          .collection(AppConstants.bookingsCollection)
          .add(booking.toFirestore());
      
      final createdBooking = booking.rebuild((b) => b..id = docRef.id);
      
      // Update slot status in parking_lots collection
      await _firestore
          .collection(AppConstants.parkingLotsCollection)
          .doc(parkingLotId)
          .collection(AppConstants.slotsSubCollection)
          .doc(slotId)
          .update({
        'status': SlotStatus.reserved.name,
        'reservedBy': userId,
        'reservedAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });
      
      return Right(createdBooking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create booking: $e'));
    }
  }
  
  @override
  Future<Result<SlotBooking>> occupyBooking({
    required String bookingId,
  }) async {
    try {
      // First, get the booking to know which slot to update
      final doc = await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .get();
      
      if (!doc.exists) {
        return const Left(ServerFailure('Booking not found'));
      }
      
      final bookingData = doc.data()!;
      final slotId = bookingData['slotId'] as String;
      final parkingLotId = bookingData['parkingLotId'] as String;
      
      final now = DateTime.now();
      
      // Update booking status
      await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .update({
        'status': SlotStatus.occupied.name,
        'occupiedAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });
      
      // Update slot status in parking_lots collection
      await _firestore
          .collection(AppConstants.parkingLotsCollection)
          .doc(parkingLotId)
          .collection(AppConstants.slotsSubCollection)
          .doc(slotId)
          .update({
        'status': SlotStatus.occupied.name,
        'occupiedAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });
      
      // Get updated booking
      final updatedDoc = await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .get();
      
      final booking = SlotBooking.fromFirestore(updatedDoc.data()!, updatedDoc.id);
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to occupy booking: $e'));
    }
  }
  
  @override
  Future<Result<void>> releaseBooking({
    required String bookingId,
  }) async {
    try {
      // First, get the booking to know which slot to update
      final doc = await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .get();
      
      if (!doc.exists) {
        return const Left(ServerFailure('Booking not found'));
      }
      
      final bookingData = doc.data()!;
      final slotId = bookingData['slotId'] as String;
      final parkingLotId = bookingData['parkingLotId'] as String;
      
      final now = DateTime.now();
      
      // Update booking status
      await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .update({
        'status': SlotStatus.available.name,
        'releasedAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });
      
      // Update slot status in parking_lots collection - make it available
      await _firestore
          .collection(AppConstants.parkingLotsCollection)
          .doc(parkingLotId)
          .collection(AppConstants.slotsSubCollection)
          .doc(slotId)
          .update({
        'status': SlotStatus.available.name,
        'reservedBy': null,
        'reservedAt': null,
        'occupiedAt': null,
        'updatedAt': now.toIso8601String(),
      });
      
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to release booking: $e'));
    }
  }
  
  @override
  Stream<Result<List<SlotBooking>>> watchTodayBookings({
    required String parkingLotId,
  }) {
    try {
      final today = _dateOnly(DateTime.now());
      final dateStr = today.toIso8601String();
      
      return _firestore
          .collection(AppConstants.bookingsCollection)
          .where('parkingLotId', isEqualTo: parkingLotId)
          .where('bookingDate', isEqualTo: dateStr)
          .snapshots()
          .map((snapshot) {
        final bookings = snapshot.docs
            .map((doc) => SlotBooking.fromFirestore(doc.data(), doc.id))
            .toList();
        
        return Right<Failure, List<SlotBooking>>(bookings);
      });
    } on ServerException catch (e) {
      return Stream.value(Left(ServerFailure(e.message)));
    } catch (e) {
      return Stream.value(Left(ServerFailure('Failed to watch bookings: $e')));
    }
  }
  
  @override
  Future<Result<SlotBooking>> getBookingById(String bookingId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .get();
      
      if (!doc.exists) {
        return const Left(ServerFailure('Booking not found'));
      }
      
      final booking = SlotBooking.fromFirestore(doc.data()!, doc.id);
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get booking: $e'));
    }
  }
}
