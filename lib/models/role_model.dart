class Role {
  int? roleId;
  String name;
  String? description;
  DateTime createdAt;

  Role({
    this.roleId,
    required this.name,
    this.description,
    required this.createdAt,
  });

  // Convert a Role object into a Map for SQLite.
  Map<String, dynamic> toSqlite() {
    return {
      'roleId': roleId,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert a Map from SQLite into a Role object.
  static Role fromSqlite(Map<String, dynamic> map) {
    return Role(
      roleId: map['roleId'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
