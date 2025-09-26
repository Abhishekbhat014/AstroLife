import 'package:astro_life/core/database_helper.dart';
import 'package:astro_life/models/role_model.dart';
import 'package:sqflite/sqflite.dart';

class RoleService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Create a new role.
  Future<int> createRole(Role role) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'Roles',
      role.toSqlite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Find a role by its name.
  Future<Role?> getRoleByName(String name) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Roles',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return Role.fromSqlite(maps.first);
    }
    return null;
  }
}
