import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/parking_lot.dart';
import '../../domain/entities/parking_slot.dart';

/// Remote data source for parking operations using Firebase
/// Follows Single Responsibility Principle
abstract class ParkingRemoteDataSource {
  Future<List<ParkingLot>> getParkingLots();
  Future<ParkingLot> getParkingLotById(String id);
  Stream<ParkingLot> watchParkingLot(String id);
  Future<List<ParkingSlot>> getSlots(String parkingLotId);
  Future<ParkingSlot> getSlotById(String parkingLotId, String slotId);
  Stream<List<ParkingSlot>> watchSlots(String parkingLotId);
  Future<void> updateSlot(
    String parkingLotId,
    String slotId,
    Map<String, dynamic> data,
  );
}

class ParkingRemoteDataSourceImpl implements ParkingRemoteDataSource {
  final FirebaseFirestore _firestore;
  
  ParkingRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;
  
  @override
  Future<List<ParkingLot>> getParkingLots() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.parkingLotsCollection)
          .get();
      
      final List<ParkingLot> lots = [];
      
      for (var doc in snapshot.docs) {
        // Get slots for this parking lot
        final slots = await getSlots(doc.id);
        
        final lot = ParkingLot.fromFirestore(
          doc.data(),
          doc.id,
          slotsList: slots,
        );
        lots.add(lot);
      }
      
      return lots;
    } catch (e) {
      throw ServerException('Failed to get parking lots: $e');
    }
  }
  
  @override
  Future<ParkingLot> getParkingLotById(String id) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.parkingLotsCollection)
          .doc(id)
          .get();
      
      if (!doc.exists) {
        throw ServerException('Parking lot not found');
      }
      
      // Get slots for this parking lot
      final slots = await getSlots(id);
      
      return ParkingLot.fromFirestore(
        doc.data()!,
        doc.id,
        slotsList: slots,
      );
    } catch (e) {
      throw ServerException('Failed to get parking lot: $e');
    }
  }
  
  @override
  Stream<ParkingLot> watchParkingLot(String id) {
    try {
      return _firestore
          .collection(AppConstants.parkingLotsCollection)
          .doc(id)
          .snapshots()
          .asyncMap((doc) async {
        if (!doc.exists) {
          throw ServerException('Parking lot not found');
        }
        
        // Get slots for this parking lot
        final slots = await getSlots(id);
        
        return ParkingLot.fromFirestore(
          doc.data()!,
          doc.id,
          slotsList: slots,
        );
      });
    } catch (e) {
      throw ServerException('Failed to watch parking lot: $e');
    }
  }
  
  @override
  Future<List<ParkingSlot>> getSlots(String parkingLotId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.parkingLotsCollection)
          .doc(parkingLotId)
          .collection(AppConstants.slotsSubCollection)
          .get();
      
      return snapshot.docs
          .map((doc) => ParkingSlot.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get slots: $e');
    }
  }
  
  @override
  Future<ParkingSlot> getSlotById(
    String parkingLotId,
    String slotId,
  ) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.parkingLotsCollection)
          .doc(parkingLotId)
          .collection(AppConstants.slotsSubCollection)
          .doc(slotId)
          .get();
      
      if (!doc.exists) {
        throw ServerException('Slot not found');
      }
      
      return ParkingSlot.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException('Failed to get slot: $e');
    }
  }
  
  @override
  Stream<List<ParkingSlot>> watchSlots(String parkingLotId) {
    try {
      return _firestore
          .collection(AppConstants.parkingLotsCollection)
          .doc(parkingLotId)
          .collection(AppConstants.slotsSubCollection)
          .orderBy('slotNumber')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => ParkingSlot.fromFirestore(doc.data(), doc.id))
            .toList();
      });
    } catch (e) {
      throw ServerException('Failed to watch slots: $e');
    }
  }
  
  @override
  Future<void> updateSlot(
    String parkingLotId,
    String slotId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore
          .collection(AppConstants.parkingLotsCollection)
          .doc(parkingLotId)
          .collection(AppConstants.slotsSubCollection)
          .doc(slotId)
          .update(data);
    } catch (e) {
      throw ServerException('Failed to update slot: $e');
    }
  }
}
