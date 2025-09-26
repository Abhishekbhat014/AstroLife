import 'package:astro_life/core/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class UserRoleService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Assign a role to a user.
  Future<int> assignRoleToUser(int userId, int roleId) async {
    final db = await _dbHelper.database;
    return await db.insert('UserRoles', {
      'userId': userId,
      'roleId': roleId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }
}
