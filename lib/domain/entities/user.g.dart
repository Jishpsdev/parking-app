// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<User> _$userSerializer = _$UserSerializer();

class _$UserSerializer implements StructuredSerializer<User> {
  @override
  final Iterable<Type> types = const [User, _$User];
  @override
  final String wireName = 'User';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    User object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'userType',
      serializers.serialize(
        object.userType,
        specifiedType: const FullType(UserType),
      ),
    ];
    Object? value;
    value = object.currentLocation;
    if (value != null) {
      result
        ..add('currentLocation')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(GeoPoint)),
        );
    }
    value = object.activeReservationId;
    if (value != null) {
      result
        ..add('activeReservationId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  User deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserBuilder();

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
        case 'userType':
          result.userType =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(UserType),
                  )!
                  as UserType;
          break;
        case 'currentLocation':
          result.currentLocation.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(GeoPoint),
                )!
                as GeoPoint,
          );
          break;
        case 'activeReservationId':
          result.activeReservationId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$User extends User {
  @override
  final String id;
  @override
  final String name;
  @override
  final UserType userType;
  @override
  final GeoPoint? currentLocation;
  @override
  final String? activeReservationId;

  factory _$User([void Function(UserBuilder)? updates]) =>
      (UserBuilder()..update(updates))._build();

  _$User._({
    required this.id,
    required this.name,
    required this.userType,
    this.currentLocation,
    this.activeReservationId,
  }) : super._();
  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        id == other.id &&
        name == other.name &&
        userType == other.userType &&
        currentLocation == other.currentLocation &&
        activeReservationId == other.activeReservationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, userType.hashCode);
    _$hash = $jc(_$hash, currentLocation.hashCode);
    _$hash = $jc(_$hash, activeReservationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'User')
          ..add('id', id)
          ..add('name', name)
          ..add('userType', userType)
          ..add('currentLocation', currentLocation)
          ..add('activeReservationId', activeReservationId))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  UserType? _userType;
  UserType? get userType => _$this._userType;
  set userType(UserType? userType) => _$this._userType = userType;

  GeoPointBuilder? _currentLocation;
  GeoPointBuilder get currentLocation =>
      _$this._currentLocation ??= GeoPointBuilder();
  set currentLocation(GeoPointBuilder? currentLocation) =>
      _$this._currentLocation = currentLocation;

  String? _activeReservationId;
  String? get activeReservationId => _$this._activeReservationId;
  set activeReservationId(String? activeReservationId) =>
      _$this._activeReservationId = activeReservationId;

  UserBuilder();

  UserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _userType = $v.userType;
      _currentLocation = $v.currentLocation?.toBuilder();
      _activeReservationId = $v.activeReservationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  User build() => _build();

  _$User _build() {
    _$User _$result;
    try {
      _$result =
          _$v ??
          _$User._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'User', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(name, r'User', 'name'),
            userType: BuiltValueNullFieldError.checkNotNull(
              userType,
              r'User',
              'userType',
            ),
            currentLocation: _currentLocation?.build(),
            activeReservationId: activeReservationId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'currentLocation';
        _currentLocation?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'User', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
