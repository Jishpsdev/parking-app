// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_booking.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SlotBooking> _$slotBookingSerializer = _$SlotBookingSerializer();

class _$SlotBookingSerializer implements StructuredSerializer<SlotBooking> {
  @override
  final Iterable<Type> types = const [SlotBooking, _$SlotBooking];
  @override
  final String wireName = 'SlotBooking';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    SlotBooking object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'slotId',
      serializers.serialize(
        object.slotId,
        specifiedType: const FullType(String),
      ),
      'userId',
      serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      ),
      'parkingLotId',
      serializers.serialize(
        object.parkingLotId,
        specifiedType: const FullType(String),
      ),
      'bookingDate',
      serializers.serialize(
        object.bookingDate,
        specifiedType: const FullType(DateTime),
      ),
      'status',
      serializers.serialize(
        object.status,
        specifiedType: const FullType(SlotStatus),
      ),
      'reservedAt',
      serializers.serialize(
        object.reservedAt,
        specifiedType: const FullType(DateTime),
      ),
    ];
    Object? value;
    value = object.occupiedAt;
    if (value != null) {
      result
        ..add('occupiedAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    value = object.releasedAt;
    if (value != null) {
      result
        ..add('releasedAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    return result;
  }

  @override
  SlotBooking deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SlotBookingBuilder();

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
        case 'slotId':
          result.slotId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'userId':
          result.userId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'parkingLotId':
          result.parkingLotId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'bookingDate':
          result.bookingDate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'status':
          result.status =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(SlotStatus),
                  )!
                  as SlotStatus;
          break;
        case 'reservedAt':
          result.reservedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'occupiedAt':
          result.occupiedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
        case 'releasedAt':
          result.releasedAt =
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

class _$SlotBooking extends SlotBooking {
  @override
  final String id;
  @override
  final String slotId;
  @override
  final String userId;
  @override
  final String parkingLotId;
  @override
  final DateTime bookingDate;
  @override
  final SlotStatus status;
  @override
  final DateTime reservedAt;
  @override
  final DateTime? occupiedAt;
  @override
  final DateTime? releasedAt;

  factory _$SlotBooking([void Function(SlotBookingBuilder)? updates]) =>
      (SlotBookingBuilder()..update(updates))._build();

  _$SlotBooking._({
    required this.id,
    required this.slotId,
    required this.userId,
    required this.parkingLotId,
    required this.bookingDate,
    required this.status,
    required this.reservedAt,
    this.occupiedAt,
    this.releasedAt,
  }) : super._();
  @override
  SlotBooking rebuild(void Function(SlotBookingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SlotBookingBuilder toBuilder() => SlotBookingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SlotBooking &&
        id == other.id &&
        slotId == other.slotId &&
        userId == other.userId &&
        parkingLotId == other.parkingLotId &&
        bookingDate == other.bookingDate &&
        status == other.status &&
        reservedAt == other.reservedAt &&
        occupiedAt == other.occupiedAt &&
        releasedAt == other.releasedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, slotId.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, parkingLotId.hashCode);
    _$hash = $jc(_$hash, bookingDate.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reservedAt.hashCode);
    _$hash = $jc(_$hash, occupiedAt.hashCode);
    _$hash = $jc(_$hash, releasedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SlotBooking')
          ..add('id', id)
          ..add('slotId', slotId)
          ..add('userId', userId)
          ..add('parkingLotId', parkingLotId)
          ..add('bookingDate', bookingDate)
          ..add('status', status)
          ..add('reservedAt', reservedAt)
          ..add('occupiedAt', occupiedAt)
          ..add('releasedAt', releasedAt))
        .toString();
  }
}

class SlotBookingBuilder implements Builder<SlotBooking, SlotBookingBuilder> {
  _$SlotBooking? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _slotId;
  String? get slotId => _$this._slotId;
  set slotId(String? slotId) => _$this._slotId = slotId;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _parkingLotId;
  String? get parkingLotId => _$this._parkingLotId;
  set parkingLotId(String? parkingLotId) => _$this._parkingLotId = parkingLotId;

  DateTime? _bookingDate;
  DateTime? get bookingDate => _$this._bookingDate;
  set bookingDate(DateTime? bookingDate) => _$this._bookingDate = bookingDate;

  SlotStatus? _status;
  SlotStatus? get status => _$this._status;
  set status(SlotStatus? status) => _$this._status = status;

  DateTime? _reservedAt;
  DateTime? get reservedAt => _$this._reservedAt;
  set reservedAt(DateTime? reservedAt) => _$this._reservedAt = reservedAt;

  DateTime? _occupiedAt;
  DateTime? get occupiedAt => _$this._occupiedAt;
  set occupiedAt(DateTime? occupiedAt) => _$this._occupiedAt = occupiedAt;

  DateTime? _releasedAt;
  DateTime? get releasedAt => _$this._releasedAt;
  set releasedAt(DateTime? releasedAt) => _$this._releasedAt = releasedAt;

  SlotBookingBuilder();

  SlotBookingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _slotId = $v.slotId;
      _userId = $v.userId;
      _parkingLotId = $v.parkingLotId;
      _bookingDate = $v.bookingDate;
      _status = $v.status;
      _reservedAt = $v.reservedAt;
      _occupiedAt = $v.occupiedAt;
      _releasedAt = $v.releasedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SlotBooking other) {
    _$v = other as _$SlotBooking;
  }

  @override
  void update(void Function(SlotBookingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SlotBooking build() => _build();

  _$SlotBooking _build() {
    final _$result =
        _$v ??
        _$SlotBooking._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'SlotBooking', 'id'),
          slotId: BuiltValueNullFieldError.checkNotNull(
            slotId,
            r'SlotBooking',
            'slotId',
          ),
          userId: BuiltValueNullFieldError.checkNotNull(
            userId,
            r'SlotBooking',
            'userId',
          ),
          parkingLotId: BuiltValueNullFieldError.checkNotNull(
            parkingLotId,
            r'SlotBooking',
            'parkingLotId',
          ),
          bookingDate: BuiltValueNullFieldError.checkNotNull(
            bookingDate,
            r'SlotBooking',
            'bookingDate',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'SlotBooking',
            'status',
          ),
          reservedAt: BuiltValueNullFieldError.checkNotNull(
            reservedAt,
            r'SlotBooking',
            'reservedAt',
          ),
          occupiedAt: occupiedAt,
          releasedAt: releasedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
