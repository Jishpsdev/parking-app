import 'package:cloud_firestore/cloud_firestore.dart';

/// Populate Firestore with sample parking data
/// Call this function ONCE from your app, then remove the call
Future<void> populateSampleParkingData() async {
  final firestore = FirebaseFirestore.instance;
  
  print('🚀 Starting data population...');
  print('');
  

  // ============ Create Parking Lot ============
  print('📍 Creating parking lot...');
  
  // Create parking lot
  final lotId = 'lot_001';
  final lotRef = firestore.collection('parking_lots').doc(lotId);
  
  await lotRef.set({
    'name': 'Main Parking Complex',
    'address': 'Multi-level Parking Structure',
    'location': {
      'latitude': 37.7749,
      'longitude': -122.4194,
    },
    'geofenceRadius': 100.0,
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
  });
  
  final slotsRef = lotRef.collection('slots');
  
  // Car slots with floor and wing
  final carSlots = [
    {'slotNumber': '184', 'floor': 4, 'wing': 'A'},
    {'slotNumber': '205', 'floor': 4, 'wing': 'B'},
    {'slotNumber': '210', 'floor': 4, 'wing': 'B'},
    {'slotNumber': '211', 'floor': 4, 'wing': 'B'},
    {'slotNumber': '277', 'floor': 6, 'wing': 'A'},
    {'slotNumber': '287', 'floor': 6, 'wing': 'A'},
    {'slotNumber': '296', 'floor': 6, 'wing': 'A'},
    {'slotNumber': '318', 'floor': 6, 'wing': 'B'},
    {'slotNumber': '320', 'floor': 6, 'wing': 'B'},
    {'slotNumber': '382', 'floor': 7, 'wing': 'B'},
  ];
  
  print('🚗 Creating ${carSlots.length} car slots...');
  for (final slot in carSlots) {
    final docId = 'slot_car_${slot['slotNumber']}';
    await slotsRef.doc(docId).set({
      'slotNumber': slot['slotNumber'],
      'type': 'car',
      'status': 'available',
      'floor': slot['floor'],
      'wing': slot['wing'],
      'reservedBy': null,
      'reservedAt': null,
      'occupiedAt': null,
      'updatedAt': DateTime.now().toIso8601String(),
    });
    print('  ✓ Car slot ${slot['slotNumber']} (F${slot['floor']}-${slot['wing']})');
  }
  
  // Bike slots (assigned to Ground Floor, Wing B)
  final bikeSlotNumbers = [
    '48', '49', '50', '51', '52', '59', '60', '61', '62', '63',
    '64', '65', '66', '67', '68', '69', '70', '71', '72', '96',
    '287', '325', '326', '327', '336', '356', '357', '499', '500', '501',
    '502', '503', '504', '505', '506',
  ];
  
  print('🏍️  Creating ${bikeSlotNumbers.length} bike slots...');
  for (final slotNumber in bikeSlotNumbers) {
    final docId = 'slot_bike_$slotNumber';
    await slotsRef.doc(docId).set({
      'slotNumber': slotNumber,
      'type': 'bike',
      'status': 'available',
      'floor': 0, // Ground floor
      'wing': 'B',
      'reservedBy': null,
      'reservedAt': null,
      'occupiedAt': null,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
  print('  ✓ Created ${bikeSlotNumbers.length} bike slots');
  
  print('');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('✅ DATA POPULATION COMPLETE!');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('📊 Summary:');
  print('   • Parking Lots: 1');
  print('   • Car Slots: ${carSlots.length}');
  print('   • Bike Slots: ${bikeSlotNumbers.length}');
  print('   • Total Slots: ${carSlots.length + bikeSlotNumbers.length}');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('');
}
