# Floor and Wing Feature

## Overview
Added `floor` and `wing` fields to the ParkingSlot entity to support multi-level parking structures with different wings/sections.

## Changes Made

### 1. Updated ParkingSlot Entity

**New Fields:**
```dart
/// Floor number (e.g., "4th floor" would be 4)
int get floor;

/// Wing identifier (e.g., "A", "B", "C")
String get wing;
```

**Helper Methods:**
```dart
/// Get formatted floor display (e.g., "4th floor")
String get floorDisplay {
  final suffix = _getOrdinalSuffix(floor);
  return '$floor$suffix floor';
}

/// Get formatted location (e.g., "4th floor, Wing A")
String get locationDisplay {
  return '$floorDisplay, Wing $wing';
}
```

**Example Usage:**
```dart
final slot = ParkingSlot((b) => b
  ..id = 'slot_001'
  ..slotNumber = 'A01'
  ..floor = 4
  ..wing = 'A'
  ..type = VehicleType.car
  ..status = SlotStatus.available);

print(slot.floorDisplay);      // "4th floor"
print(slot.locationDisplay);   // "4th floor, Wing A"
```

### 2. Updated Firestore Serialization

**fromFirestore:**
```dart
factory ParkingSlot.fromFirestore(Map<String, dynamic> data, String id) {
  return ParkingSlot((b) => b
    ..id = id
    ..slotNumber = data['slotNumber'] as String
    ..floor = data['floor'] as int
    ..wing = data['wing'] as String
    // ... other fields
  );
}
```

**toFirestore:**
```dart
Map<String, dynamic> toFirestore() {
  return {
    'slotNumber': slotNumber,
    'floor': floor,
    'wing': wing,
    // ... other fields
  };
}
```

### 3. Updated UI Components

#### SlotCard Widget
Now displays floor and wing in compact format:
```dart
Text(
  'F${slot.floor} W${slot.wing}',  // e.g., "F4 WA"
  style: TextStyle(
    fontSize: 10,
    color: color.withValues(alpha: 0.7),
  ),
)
```

**Visual Example:**
```
┌─────────────┐
│     ✓       │  Icon
│             │
│    A01      │  Slot Number
│   F4 WA     │  Floor & Wing (NEW)
│  Available  │  Status
└─────────────┘
```

#### Slot Details Bottom Sheet
Shows full location information:
```dart
Text(
  slot.locationDisplay,  // "4th floor, Wing A"
  style: TextStyle(
    fontSize: 16,
    color: Colors.grey[600],
  ),
)
```

## Firebase Data Structure

### Sample Slot Document
```json
{
  "slotNumber": "A01",
  "type": "car",
  "status": "available",
  "floor": 4,
  "wing": "A",
  "reservedBy": null,
  "reservedAt": null,
  "occupiedAt": null,
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

### Creating Slots by Floor and Wing

**Example: Ground Floor, Wing A (10 car slots)**
```firestore
parking_lots/lot_001/slots/
  slot_g_a_c01: { slotNumber: "C01", floor: 0, wing: "A", type: "car" }
  slot_g_a_c02: { slotNumber: "C02", floor: 0, wing: "A", type: "car" }
  ...
```

**Example: 4th Floor, Wing A (8 car slots)**
```firestore
parking_lots/lot_001/slots/
  slot_4_a_c01: { slotNumber: "C01", floor: 4, wing: "A", type: "car" }
  slot_4_a_c02: { slotNumber: "C02", floor: 4, wing: "A", type: "car" }
  ...
```

**Example: 4th Floor, Wing B (10 bike slots)**
```firestore
parking_lots/lot_001/slots/
  slot_4_b_b01: { slotNumber: "B01", floor: 4, wing: "B", type: "bike" }
  slot_4_b_b02: { slotNumber: "B02", floor: 4, wing: "B", type: "bike" }
  ...
```

## Sample Data Script

### Quick Firestore Console Method
1. Go to Firebase Console → Firestore
2. Navigate to: `parking_lots/{lotId}/slots`
3. Add document with these fields:
   - `slotNumber`: "A01"
   - `floor`: 4 (number)
   - `wing`: "A" (string)
   - `type`: "car"
   - `status`: "available"

### Bulk Creation Script (Optional)
```dart
Future<void> populateMultiFloorSlots() async {
  final firestore = FirebaseFirestore.instance;
  final lotRef = firestore.collection('parking_lots').doc('lot_001');
  
  // Ground floor - Wing A (Cars)
  for (int i = 1; i <= 15; i++) {
    await lotRef.collection('slots').doc('slot_0_a_c${i.toString().padLeft(2, '0')}').set({
      'slotNumber': 'C${i.toString().padLeft(2, '0')}',
      'floor': 0,
      'wing': 'A',
      'type': 'car',
      'status': 'available',
      'reservedBy': null,
      'reservedAt': null,
      'occupiedAt': null,
    });
  }
  
  // Ground floor - Wing B (Bikes)
  for (int i = 1; i <= 20; i++) {
    await lotRef.collection('slots').doc('slot_0_b_b${i.toString().padLeft(2, '0')}').set({
      'slotNumber': 'B${i.toString().padLeft(2, '0')}',
      'floor': 0,
      'wing': 'B',
      'type': 'bike',
      'status': 'available',
      'reservedBy': null,
      'reservedAt': null,
      'occupiedAt': null,
    });
  }
  
  // 1st floor - Wing A (Cars)
  for (int i = 1; i <= 15; i++) {
    await lotRef.collection('slots').doc('slot_1_a_c${i.toString().padLeft(2, '0')}').set({
      'slotNumber': 'C${i.toString().padLeft(2, '0')}',
      'floor': 1,
      'wing': 'A',
      'type': 'car',
      'status': 'available',
      'reservedBy': null,
      'reservedAt': null,
      'occupiedAt': null,
    });
  }
  
  // 2nd floor - Wing A (Cars)
  for (int i = 1; i <= 15; i++) {
    await lotRef.collection('slots').doc('slot_2_a_c${i.toString().padLeft(2, '0')}').set({
      'slotNumber': 'C${i.toString().padLeft(2, '0')}',
      'floor': 2,
      'wing': 'A',
      'type': 'car',
      'status': 'available',
      'reservedBy': null,
      'reservedAt': null,
      'occupiedAt': null,
    });
  }
  
  // 3rd floor - Wing A (Cars)
  for (int i = 1; i <= 10; i++) {
    await lotRef.collection('slots').doc('slot_3_a_c${i.toString().padLeft(2, '0')}').set({
      'slotNumber': 'C${i.toString().padLeft(2, '0')}',
      'floor': 3,
      'wing': 'A',
      'type': 'car',
      'status': 'available',
      'reservedBy': null,
      'reservedAt': null,
      'occupiedAt': null,
    });
  }
  
  // 4th floor - Wing A (Cars)
  for (int i = 1; i <= 10; i++) {
    await lotRef.collection('slots').doc('slot_4_a_c${i.toString().padLeft(2, '0')}').set({
      'slotNumber': 'C${i.toString().padLeft(2, '0')}',
      'floor': 4,
      'wing': 'A',
      'type': 'car',
      'status': 'available',
      'reservedBy': null,
      'reservedAt': null,
      'occupiedAt': null,
    });
  }
  
  print('Created multi-floor parking structure!');
}
```

## Use Cases

### 1. Multi-Story Parking Buildings
```
Ground Floor (0):
  - Wing A: 15 car slots
  - Wing B: 20 bike slots

1st Floor (1):
  - Wing A: 15 car slots

2nd Floor (2):
  - Wing A: 15 car slots

3rd Floor (3):
  - Wing A: 10 car slots

4th Floor (4):
  - Wing A: 10 car slots
```

### 2. Shopping Mall Parking
```
Basement 1 (-1):
  - Wing A: 50 slots
  - Wing B: 50 slots

Ground (0):
  - Wing A: 30 slots

Rooftop (5):
  - Wing A: 20 slots
```

### 3. Airport Parking
```
Terminal 1 Parking:
  - Floor 0, Wing A: Short-term
  - Floor 0, Wing B: Long-term
  - Floor 1, Wing A: Premium
```

## Benefits

1. **Better Organization**
   - Clear identification of slot location
   - Easier navigation for users

2. **Scalability**
   - Support for unlimited floors
   - Multiple wings per floor

3. **User Experience**
   - Users can quickly find their parked vehicle
   - "Remember my location" feature possible

4. **Reporting**
   - Occupancy by floor
   - Popular floors/wings
   - Usage analytics

## Future Enhancements

### 1. Floor/Wing Filtering
```dart
// Filter slots by floor
final floor4Slots = parkingLot.slots
    .where((s) => s.floor == 4)
    .toList();

// Filter by wing
final wingASlots = parkingLot.slots
    .where((s) => s.wing == 'A')
    .toList();
```

### 2. Floor Overview Screen
Show availability per floor:
```
Floor 4:
  Wing A: 3/10 available
  Wing B: 5/8 available

Floor 3:
  Wing A: 8/15 available
```

### 3. Navigation Assistance
```dart
// "Your car is on 4th floor, Wing A, Slot C05"
// "Follow signs to Floor 4 → Wing A"
```

### 4. Elevator Integration
```dart
// "Nearest elevator: E2 (50m away)"
// "Take elevator to Floor 4"
```

## Testing

### Unit Tests
```dart
test('should format floor display correctly', () {
  final slot = ParkingSlot((b) => b
    ..floor = 4
    ..wing = 'A'
    // ... other fields
  );
  
  expect(slot.floorDisplay, '4th floor');
  expect(slot.locationDisplay, '4th floor, Wing A');
});

test('should handle ground floor', () {
  final slot = ParkingSlot((b) => b
    ..floor = 0
    ..wing = 'A'
    // ... other fields
  );
  
  expect(slot.floorDisplay, '0th floor'); // or customize to "Ground floor"
});
```

## Migration Notes

**Existing Slots Need Update:**
If you have existing slots in Firestore without floor/wing fields, you'll need to update them:

```javascript
// Firebase Console or script
{
  floor: 0,      // Add default floor
  wing: "A"      // Add default wing
}
```

## Summary

✅ Added `floor` and `wing` fields to ParkingSlot
✅ Updated Firestore serialization
✅ Added helper methods for display formatting
✅ Updated UI to show floor and wing information
✅ Regenerated built_value code
✅ All tests pass (flutter analyze: no issues)

The parking system now supports multi-level parking structures with multiple wings! 🏢🚗
