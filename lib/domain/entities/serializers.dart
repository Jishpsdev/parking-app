import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'geo_point.dart';
import 'parking_lot.dart';
import 'parking_slot.dart';
import 'slot_booking.dart';
import 'user.dart';

part 'serializers.g.dart';

/// Collection of serializers for built_value models
@SerializersFor([
  GeoPoint,
  ParkingSlot,
  ParkingLot,
  SlotBooking,
  User,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin()))
    .build();
