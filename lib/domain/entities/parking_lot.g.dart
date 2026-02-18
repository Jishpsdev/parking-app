// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_lot.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ParkingLot> _$parkingLotSerializer = _$ParkingLotSerializer();

class _$ParkingLotSerializer implements StructuredSerializer<ParkingLot> {
  @override
  final Iterable<Type> types = const [ParkingLot, _$ParkingLot];
  @override
  final String wireName = 'ParkingLot';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ParkingLot object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'address',
      serializers.serialize(
        object.address,
        specifiedType: const FullType(String),
      ),
      'location',
      serializers.serialize(
        object.location,
        specifiedType: const FullType(GeoPoint),
      ),
      'geofenceRadius',
      serializers.serialize(
        object.geofenceRadius,
        specifiedType: const FullType(double),
      ),
      'slots',
      serializers.serialize(
        object.slots,
        specifiedType: const FullType(BuiltList, const [
          const FullType(ParkingSlot),
        ]),
      ),
    ];

    return result;
  }

  @override
  ParkingLot deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParkingLotBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'address':
          result.address =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'location':
          result.location.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(GeoPoint),
                )!
                as GeoPoint,
          );
          break;
        case 'geofenceRadius':
          result.geofenceRadius =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )!
                  as double;
          break;
        case 'slots':
          result.slots.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(ParkingSlot),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$ParkingLot extends ParkingLot {
  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  final GeoPoint location;
  @override
  final double geofenceRadius;
  @override
  final BuiltList<ParkingSlot> slots;

  factory _$ParkingLot([void Function(ParkingLotBuilder)? updates]) =>
      (ParkingLotBuilder()..update(updates))._build();

  _$ParkingLot._({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.geofenceRadius,
    required this.slots,
  }) : super._();
  @override
  ParkingLot rebuild(void Function(ParkingLotBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParkingLotBuilder toBuilder() => ParkingLotBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParkingLot &&
        id == other.id &&
        name == other.name &&
        address == other.address &&
        location == other.location &&
        geofenceRadius == other.geofenceRadius &&
        slots == other.slots;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, geofenceRadius.hashCode);
    _$hash = $jc(_$hash, slots.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParkingLot')
          ..add('id', id)
          ..add('name', name)
          ..add('address', address)
          ..add('location', location)
          ..add('geofenceRadius', geofenceRadius)
          ..add('slots', slots))
        .toString();
  }
}

class ParkingLotBuilder implements Builder<ParkingLot, ParkingLotBuilder> {
  _$ParkingLot? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  GeoPointBuilder? _location;
  GeoPointBuilder get location => _$this._location ??= GeoPointBuilder();
  set location(GeoPointBuilder? location) => _$this._location = location;

  double? _geofenceRadius;
  double? get geofenceRadius => _$this._geofenceRadius;
  set geofenceRadius(double? geofenceRadius) =>
      _$this._geofenceRadius = geofenceRadius;

  ListBuilder<ParkingSlot>? _slots;
  ListBuilder<ParkingSlot> get slots =>
      _$this._slots ??= ListBuilder<ParkingSlot>();
  set slots(ListBuilder<ParkingSlot>? slots) => _$this._slots = slots;

  ParkingLotBuilder();

  ParkingLotBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _address = $v.address;
      _location = $v.location.toBuilder();
      _geofenceRadius = $v.geofenceRadius;
      _slots = $v.slots.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParkingLot other) {
    _$v = other as _$ParkingLot;
  }

  @override
  void update(void Function(ParkingLotBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParkingLot build() => _build();

  _$ParkingLot _build() {
    _$ParkingLot _$result;
    try {
      _$result =
          _$v ??
          _$ParkingLot._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'ParkingLot', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'ParkingLot',
              'name',
            ),
            address: BuiltValueNullFieldError.checkNotNull(
              address,
              r'ParkingLot',
              'address',
            ),
            location: location.build(),
            geofenceRadius: BuiltValueNullFieldError.checkNotNull(
              geofenceRadius,
              r'ParkingLot',
              'geofenceRadius',
            ),
            slots: slots.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();

        _$failedField = 'slots';
        slots.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ParkingLot',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
