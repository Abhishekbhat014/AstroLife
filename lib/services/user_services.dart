import 'package:astro_life/core/database_helper.dart';
import 'package:astro_life/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class UserService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Create a new user in the database.
  Future<int> createUser(User user) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'User',
      user.toSqlite(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Find a user by their email address.
  Future<User?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromSqlite(maps.first);
    }
    return null;
  }

  // UPDATED: Updates the user's password based on email.
  Future<int> updatePassword(String email, String newPassword) async {
    final db = await _dbHelper.database;

    // NOTE: For local prototype simplicity, we are saving the plain password.
    // In a production app, newPassword should be securely hashed before saving.

    // Check if the user exists before attempting to update
    final userExists = await getUserByEmail(email) != null;
    if (!userExists) {
      throw Exception("User account not found for reset.");
    }

    // Perform the update
    return await db.update(
      'User',
      {'password': newPassword, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
