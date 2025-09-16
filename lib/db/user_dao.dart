import 'package:astro_life/db/database_helper.dart';
import 'package:astro_life/models/user.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserDao {
  // ✅ Hash password before saving
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  /// Insert new user (Registration)
  Future<int> insertUser(User user) async {
    final db = await DatabaseHelper().database;

    final userWithHash = User(
      userId: user.userId,
      firstName: user.firstName,
      middleName: user.middleName,
      lastName: user.lastName,
      motherName: user.motherName,
      gender: user.gender,
      dob: user.dob,
      birthPlace: user.birthPlace,
      address: user.address,
      email: user.email,
      password: _hashPassword(user.password), // ✅ hash password
      contact: user.contact,
      roleId: user.roleId,
      createdAt: user.createdAt,
    );

    return await db.insert("users", userWithHash.toMap());
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await DatabaseHelper().database;
    final res = await db.query(
      "users",
      where: "Email = ? AND Password = ?",
      whereArgs: [email.trim(), password.trim()],
    );
    if (res.isNotEmpty) return User.fromMap(res.first);
    return null;
  }

  /// Get user by Email
  Future<User?> getUserByEmail(String email) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      "users",
      where: "Email = ?",
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  /// Login check (email + password)
  Future<User?> loginUser(String email, String password) async {
    final db = await DatabaseHelper().database;
    final hashedPassword = _hashPassword(password);

    final result = await db.query(
      "users",
      where: "Email = ? AND Password = ?",
      whereArgs: [email, hashedPassword],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  /// Upgrade user role (Customer -> Astrologer)
  Future<int> upgradeRole(int userId, int newRoleId) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      "users",
      {"Role_ID": newRoleId}, // ✅ column name fix
      where: "User_ID = ?", // ✅ column name fix
      whereArgs: [userId],
    );
  }

  /// Get all users (debug)
  Future<List<User>> getAllUsers() async {
    final db = await DatabaseHelper().database;
    final result = await db.query("users");
    return result.map((map) => User.fromMap(map)).toList();
  }
}
