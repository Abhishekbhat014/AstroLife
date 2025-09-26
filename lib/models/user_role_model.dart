class UserRole {
  int userId;
  int roleId;

  UserRole({required this.userId, required this.roleId});

  // Convert a UserRole object into a Map for SQLite.
  Map<String, dynamic> toSqlite() {
    return {'userId': userId, 'roleId': roleId};
  }

  // Convert a Map from SQLite into a UserRole object.
  static UserRole fromSqlite(Map<String, dynamic> map) {
    return UserRole(userId: map['userId'], roleId: map['roleId']);
  }
}
