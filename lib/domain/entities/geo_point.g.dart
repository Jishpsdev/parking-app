// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GeoPoint> _$geoPointSerializer = _$GeoPointSerializer();

class _$GeoPointSerializer implements StructuredSerializer<GeoPoint> {
  @override
  final Iterable<Type> types = const [GeoPoint, _$GeoPoint];
  @override
  final String wireName = 'GeoPoint';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    GeoPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'latitude',
      serializers.serialize(
        object.latitude,
        specifiedType: const FullType(double),
      ),
      'longitude',
      serializers.serialize(
        object.longitude,
        specifiedType: const FullType(double),
      ),
    ];

    return result;
  }

  @override
  GeoPoint deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoPointBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'latitude':
          result.latitude =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )!
                  as double;
          break;
        case 'longitude':
          result.longitude =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )!
                  as double;
          break;
      }
    }

    return result.build();
  }
}

class _$GeoPoint extends GeoPoint {
  @override
  final double latitude;
  @override
  final double longitude;

  factory _$GeoPoint([void Function(GeoPointBuilder)? updates]) =>
      (GeoPointBuilder()..update(updates))._build();

  _$GeoPoint._({required this.latitude, required this.longitude}) : super._();
  @override
  GeoPoint rebuild(void Function(GeoPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeoPointBuilder toBuilder() => GeoPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeoPoint &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeoPoint')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class GeoPointBuilder implements Builder<GeoPoint, GeoPointBuilder> {
  _$GeoPoint? _$v;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  GeoPointBuilder();

  GeoPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeoPoint other) {
    _$v = other as _$GeoPoint;
  }

  @override
  void update(void Function(GeoPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeoPoint build() => _build();

  _$GeoPoint _build() {
    final _$result =
        _$v ??
        _$GeoPoint._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'GeoPoint',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'GeoPoint',
            'longitude',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
