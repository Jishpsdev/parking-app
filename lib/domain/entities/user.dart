import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'geo_point.dart';
import 'user_type.dart';

part 'user.g.dart';

/// Domain Entity representing a user
abstract class User implements Built<User, UserBuilder> {
  /// Firebase Auth UID
  String get id;
  
  String get name;
  
  /// User type determining permissions
  UserType get userType;
  
  @BuiltValueField(wireName: 'currentLocation')
  GeoPoint? get currentLocation;
  
  @BuiltValueField(wireName: 'activeReservationId')
  String? get activeReservationId;
  
  User._();
  factory User([void Function(UserBuilder) updates]) = _$User;
  
  /// Check if user has an active reservation
  bool get hasActiveReservation => activeReservationId != null;
  
  /// Check if user location is available
  bool get hasLocation => currentLocation != null;
  
  /// Check if user can reserve slots remotely (before arriving)
  bool get canReserveRemotely => userType.canReserveRemotely;
  
  /// Check if user must be on-site to book
  bool get mustBeOnSite => !canReserveRemotely;
  
  /// Serialization
  static Serializer<User> get serializer => _$userSerializer;
  
  /// From Firestore (email comes from Firebase Auth, not Firestore)
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User((b) => b
      ..id = id
      ..name = data['name'] as String
      ..userType = UserType.values.firstWhere(
        (e) => e.name == data['userType'],
        orElse: () => UserType.regular,
      )
      ..currentLocation = data['currentLocation'] != null
          ? GeoPoint.fromJson(data['currentLocation'] as Map<String, dynamic>).toBuilder()
          : null
      ..activeReservationId = data['activeReservationId'] as String?);
  }
  
  /// To Firestore (email not stored, it's in Firebase Auth)
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'userType': userType.name,
      'currentLocation': currentLocation?.toJson(),
      'activeReservationId': activeReservationId,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
