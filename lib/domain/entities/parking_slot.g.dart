// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_slot.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ParkingSlot> _$parkingSlotSerializer = _$ParkingSlotSerializer();

class _$ParkingSlotSerializer implements StructuredSerializer<ParkingSlot> {
  @override
  final Iterable<Type> types = const [ParkingSlot, _$ParkingSlot];
  @override
  final String wireName = 'ParkingSlot';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ParkingSlot object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'slotNumber',
      serializers.serialize(
        object.slotNumber,
        specifiedType: const FullType(String),
      ),
      'type',
      serializers.serialize(
        object.type,
        specifiedType: const FullType(VehicleType),
      ),
      'status',
      serializers.serialize(
        object.status,
        specifiedType: const FullType(SlotStatus),
      ),
      'floor',
      serializers.serialize(object.floor, specifiedType: const FullType(int)),
      'wing',
      serializers.serialize(object.wing, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.reservedBy;
    if (value != null) {
      result
        ..add('reservedBy')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.reservedAt;
    if (value != null) {
      result
        ..add('reservedAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    value = object.occupiedAt;
    if (value != null) {
      result
        ..add('occupiedAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    return result;
  }

  @override
  ParkingSlot deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParkingSlotBuilder();

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
        case 'slotNumber':
          result.slotNumber =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'type':
          result.type =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(VehicleType),
                  )!
                  as VehicleType;
          break;
        case 'status':
          result.status =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(SlotStatus),
                  )!
                  as SlotStatus;
          break;
        case 'floor':
          result.floor =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'wing':
          result.wing =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'reservedBy':
          result.reservedBy =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'reservedAt':
          result.reservedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
        case 'occupiedAt':
          result.occupiedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
      }
    }

    return result.build();
  }
}

class _$ParkingSlot extends ParkingSlot {
  @override
  final String id;
  @override
  final String slotNumber;
  @override
  final VehicleType type;
  @override
  final SlotStatus status;
  @override
  final int floor;
  @override
  final String wing;
  @override
  final String? reservedBy;
  @override
  final DateTime? reservedAt;
  @override
  final DateTime? occupiedAt;

  factory _$ParkingSlot([void Function(ParkingSlotBuilder)? updates]) =>
      (ParkingSlotBuilder()..update(updates))._build();

  _$ParkingSlot._({
    required this.id,
    required this.slotNumber,
    required this.type,
    required this.status,
    required this.floor,
    required this.wing,
    this.reservedBy,
    this.reservedAt,
    this.occupiedAt,
  }) : super._();
  @override
  ParkingSlot rebuild(void Function(ParkingSlotBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParkingSlotBuilder toBuilder() => ParkingSlotBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParkingSlot &&
        id == other.id &&
        slotNumber == other.slotNumber &&
        type == other.type &&
        status == other.status &&
        floor == other.floor &&
        wing == other.wing &&
        reservedBy == other.reservedBy &&
        reservedAt == other.reservedAt &&
        occupiedAt == other.occupiedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, slotNumber.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, floor.hashCode);
    _$hash = $jc(_$hash, wing.hashCode);
    _$hash = $jc(_$hash, reservedBy.hashCode);
    _$hash = $jc(_$hash, reservedAt.hashCode);
    _$hash = $jc(_$hash, occupiedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParkingSlot')
          ..add('id', id)
          ..add('slotNumber', slotNumber)
          ..add('type', type)
          ..add('status', status)
          ..add('floor', floor)
          ..add('wing', wing)
          ..add('reservedBy', reservedBy)
          ..add('reservedAt', reservedAt)
          ..add('occupiedAt', occupiedAt))
        .toString();
  }
}

class ParkingSlotBuilder implements Builder<ParkingSlot, ParkingSlotBuilder> {
  _$ParkingSlot? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _slotNumber;
  String? get slotNumber => _$this._slotNumber;
  set slotNumber(String? slotNumber) => _$this._slotNumber = slotNumber;

  VehicleType? _type;
  VehicleType? get type => _$this._type;
  set type(VehicleType? type) => _$this._type = type;

  SlotStatus? _status;
  SlotStatus? get status => _$this._status;
  set status(SlotStatus? status) => _$this._status = status;

  int? _floor;
  int? get floor => _$this._floor;
  set floor(int? floor) => _$this._floor = floor;

  String? _wing;
  String? get wing => _$this._wing;
  set wing(String? wing) => _$this._wing = wing;

  String? _reservedBy;
  String? get reservedBy => _$this._reservedBy;
  set reservedBy(String? reservedBy) => _$this._reservedBy = reservedBy;

  DateTime? _reservedAt;
  DateTime? get reservedAt => _$this._reservedAt;
  set reservedAt(DateTime? reservedAt) => _$this._reservedAt = reservedAt;

  DateTime? _occupiedAt;
  DateTime? get occupiedAt => _$this._occupiedAt;
  set occupiedAt(DateTime? occupiedAt) => _$this._occupiedAt = occupiedAt;

  ParkingSlotBuilder();

  ParkingSlotBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _slotNumber = $v.slotNumber;
      _type = $v.type;
      _status = $v.status;
      _floor = $v.floor;
      _wing = $v.wing;
      _reservedBy = $v.reservedBy;
      _reservedAt = $v.reservedAt;
      _occupiedAt = $v.occupiedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParkingSlot other) {
    _$v = other as _$ParkingSlot;
  }

  @override
  void update(void Function(ParkingSlotBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParkingSlot build() => _build();

  _$ParkingSlot _build() {
    final _$result =
        _$v ??
        _$ParkingSlot._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ParkingSlot', 'id'),
          slotNumber: BuiltValueNullFieldError.checkNotNull(
            slotNumber,
            r'ParkingSlot',
            'slotNumber',
          ),
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'ParkingSlot',
            'type',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'ParkingSlot',
            'status',
          ),
          floor: BuiltValueNullFieldError.checkNotNull(
            floor,
            r'ParkingSlot',
            'floor',
          ),
          wing: BuiltValueNullFieldError.checkNotNull(
            wing,
            r'ParkingSlot',
            'wing',
          ),
          reservedBy: reservedBy,
          reservedAt: reservedAt,
          occupiedAt: occupiedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
