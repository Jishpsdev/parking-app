/// Enum representing user types with different permissions
enum UserType {
  /// Admin users - can reserve slots remotely before arriving
  admin,
  
  /// Regular users - can only book slots when physically present
  regular;
  
  String get displayName {
    switch (this) {
      case UserType.admin:
        return 'Admin';
      case UserType.regular:
        return 'Regular';
    }
  }
  
  /// Check if user can reserve remotely
  bool get canReserveRemotely {
    switch (this) {
      case UserType.admin:
        return true;
      case UserType.regular:
        return false;
    }
  }
  
  /// Description of permissions
  String get permissionDescription {
    switch (this) {
      case UserType.admin:
        return 'Can reserve slots before arriving at the parking lot';
      case UserType.regular:
        return 'Can only book slots when physically present';
    }
  }
}
