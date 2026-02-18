# Data Population Guide

## ✅ Sample Data Added to Firestore

This guide explains how the parking lot data was populated in Firestore.

## 📊 Data Summary

### Parking Lot: `lot_001`
- **Name**: Main Parking Complex
- **Address**: Multi-level Parking Structure
- **Location**: 37.7749, -122.4194
- **Geofence Radius**: 100 meters

### Car Slots (10 total)
| Slot # | Floor | Wing |
|--------|-------|------|
| 184    | 4     | A    |
| 205    | 4     | B    |
| 210    | 4     | B    |
| 211    | 4     | B    |
| 277    | 6     | A    |
| 287    | 6     | A    |
| 296    | 6     | A    |
| 318    | 6     | B    |
| 320    | 6     | B    |
| 382    | 7     | B    |

**Distribution:**
- Floor 4: 4 slots (1 in Wing A, 3 in Wing B)
- Floor 6: 5 slots (3 in Wing A, 2 in Wing B)
- Floor 7: 1 slot (Wing B)

### Bike Slots (35 total)
All assigned to **Ground Floor (0), Wing B**

| Slot Numbers |
|--------------|
| 48, 49, 50, 51, 52, 59, 60, 61, 62, 63 |
| 64, 65, 66, 67, 68, 69, 70, 71, 72, 96 |
| 287, 325, 326, 327, 336, 356, 357 |
| 499, 500, 501, 502, 503, 504, 505, 506 |

## 🚀 How to Run the Population Script

### Method Used: One-Time App Startup

The data population function is called once when the app starts.

**File**: `lib/main.dart`
```dart
await populateSampleParkingData();
```

### Steps:

1. **First Run** - Populate Data
   ```bash
   flutter run -d chrome
   ```
   - The app will start
   - Data will be populated in Firestore
   - You'll see console logs confirming creation

2. **After Data is Populated** - Comment Out
   
   Open `lib/main.dart` and comment out the line:
   ```dart
   // await populateSampleParkingData();  // ✅ Commented out
   ```

3. **Verify in Firebase Console**
   - Go to Firebase Console → Firestore
   - Navigate to: `parking_lots/lot_001/slots`
   - You should see 45 slot documents (10 cars + 35 bikes)

## 📁 Firestore Structure

```
parking_lots/
  lot_001/
    - name: "Main Parking Complex"
    - address: "Multi-level Parking Structure"
    - location: { latitude: 37.7749, longitude: -122.4194 }
    - geofenceRadius: 100.0
    
    slots/
      slot_car_184/
        - slotNumber: "184"
        - type: "car"
        - status: "available"
        - floor: 4
        - wing: "A"
        - reservedBy: null
        - reservedAt: null
        - occupiedAt: null
        
      slot_car_205/
        - slotNumber: "205"
        - type: "car"
        - status: "available"
        - floor: 4
        - wing: "B"
        ...
        
      slot_bike_48/
        - slotNumber: "48"
        - type: "bike"
        - status: "available"
        - floor: 0
        - wing: "B"
        - reservedBy: null
        - reservedAt: null
        - occupiedAt: null
        
      ... (45 total slots)
```

## 🎯 Expected Console Output

When you run the app for the first time:

```
🚀 Starting data population...
📍 Creating parking lot: lot_001
🚗 Creating 10 car slots...
  ✓ Car slot 184 (F4-A)
  ✓ Car slot 205 (F4-B)
  ✓ Car slot 210 (F4-B)
  ✓ Car slot 211 (F4-B)
  ✓ Car slot 277 (F6-A)
  ✓ Car slot 287 (F6-A)
  ✓ Car slot 296 (F6-A)
  ✓ Car slot 318 (F6-B)
  ✓ Car slot 320 (F6-B)
  ✓ Car slot 382 (F7-B)
🏍️  Creating 35 bike slots...
  ✓ Created 35 bike slots

✅ DATA POPULATION COMPLETE!
📊 Summary:
   • Car Slots: 10
   • Bike Slots: 35
   • Total: 45 slots
```

## ⚠️ Important Notes

### 1. Run Only Once
The population function should only be run **ONE TIME**. After the data is created:
- Comment out the function call in `main.dart`
- This prevents duplicate data creation

### 2. Idempotency
The script uses document IDs like `slot_car_184`, so if you run it multiple times:
- It will **overwrite** existing slots with the same ID
- No duplicate slots will be created
- But it's still best practice to run only once

### 3. Bike Slot Floor/Wing
Since the original data didn't specify floor/wing for bikes:
- All bike slots are assigned to **Floor 0 (Ground Floor)**
- All bike slots are in **Wing B**
- You can manually update these in Firebase Console if needed

## 🔧 Troubleshooting

### Data Not Appearing?
1. Check Firebase Console → Firestore
2. Verify collection exists: `parking_lots/lot_001/slots`
3. Check console logs for errors

### Want to Reset Data?
1. Go to Firebase Console → Firestore
2. Delete collection: `parking_lots/lot_001/slots`
3. Delete document: `parking_lots/lot_001`
4. Uncomment the population function and run again

### Want to Modify Data?
**Option 1**: Edit in Firebase Console
- Navigate to the slot document
- Click Edit
- Modify fields directly

**Option 2**: Modify the script
- Edit `lib/core/utils/populate_sample_data.dart`
- Update the data arrays
- Delete existing data in Firestore
- Run the app again

## 📱 Using the App

After data population:

1. **Home Screen**: You'll see "Main Parking Complex" listed
2. **Click the parking lot**: View all slots
3. **Tabs**: Switch between Cars and Bikes
4. **Slots Display**: Each slot shows:
   - Slot number (e.g., "184")
   - Floor and Wing (e.g., "F4 WA")
   - Status (Available/Reserved/Occupied)

## 🎨 Sample UI View

### Car Slots View:
```
┌─────────┬─────────┬─────────┐
│   184   │   205   │   210   │
│  F4 WA  │  F4 WB  │  F4 WB  │
│Available│Available│Available│
└─────────┴─────────┴─────────┘
```

### Bike Slots View:
```
┌─────────┬─────────┬─────────┐
│   48    │   49    │   50    │
│  F0 WB  │  F0 WB  │  F0 WB  │
│Available│Available│Available│
└─────────┴─────────┴─────────┘
```

## 📚 Files Involved

1. **Population Function**:
   - `lib/core/utils/populate_sample_data.dart`

2. **App Entry Point**:
   - `lib/main.dart` (contains the one-time call)

3. **This Guide**:
   - `DATA_POPULATION_GUIDE.md`

---

## ✅ Checklist

- [x] Data population function created
- [x] Function called from main.dart
- [ ] Run app once to populate data
- [ ] Verify data in Firebase Console
- [ ] Comment out population call in main.dart
- [ ] Test app functionality

**Status**: Ready to run! 🚀

---

*Last Updated: Now*
*Total Slots: 45 (10 cars + 35 bikes)*
