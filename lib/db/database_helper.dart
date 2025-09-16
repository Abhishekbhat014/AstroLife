// lib/db/database_helper.dart

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;
  static const _dbName = "astro_app.db";
  static const _dbVersion = 1;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onOpen: (db) async {
        // Enable foreign keys for every connection
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onUpgrade: _onUpgrade,
    );
  }

  // Create tables
  Future _onCreate(Database db, int version) async {
    // Roles table
    await db.execute('''
      CREATE TABLE roles (
        Role_ID INTEGER PRIMARY KEY,
        Role_Name TEXT NOT NULL,
        Created_At TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Users table (common superclass)
    await db.execute('''
      CREATE TABLE users (
        User_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        First_Name TEXT NOT NULL,
        Middle_Name TEXT,
        Last_Name TEXT NOT NULL,
        Mother_Name TEXT,
        Gender INTEGER NOT NULL,
        DOB TEXT NOT NULL,
        Birth_Place TEXT,
        Address TEXT,
        Email TEXT UNIQUE NOT NULL,
        Password TEXT NOT NULL,
        Contact TEXT,
        Role_ID INTEGER NOT NULL,
        Created_At TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(Role_ID) REFERENCES roles(Role_ID)
      )
    ''');

    // Astrologers table (subclass - extra properties)
    await db.execute('''
      CREATE TABLE astrologers (
        Astrologer_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        User_ID INTEGER NOT NULL,
        Experience INTEGER,
        Specialization TEXT,
        Bio TEXT,
        Qualifications TEXT,
        Rate_Per_Minute REAL,
        Created_At TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(User_ID) REFERENCES users(User_ID) ON DELETE CASCADE
      )
    ''');

    // Insert default roles
    await db.insert("roles", {"Role_ID": 1, "Role_Name": "Customer"});
    await db.insert("roles", {"Role_ID": 2, "Role_Name": "Astrologer"});
  }

  // Handle upgrades in future versions
  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Example migration pattern (add migrations here)
    if (oldVersion < 2) {
      // await db.execute('ALTER TABLE ...');
    }
  }

  /// ---------------------
  /// CRUD & helper methods
  /// ---------------------

  /// Insert a user. `user` should be a Map with keys matching column names:
  /// e.g. {
  ///   'First_Name': 'Ravi',
  ///   'Middle_Name': 'K',
  ///   'Last_Name': 'Sharma',
  ///   'Mother_Name': 'Sita',
  ///   'Gender': 1,
  ///   'DOB': '2000-01-01',
  ///   'Birth_Place': 'Pune',
  ///   'Address': 'Some address',
  ///   'Email': 'ravi@example.com',
  ///   'Password': 'hashed_password',
  ///   'Contact': '9999999999',
  ///   'Role_ID': 1
  /// }
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  /// Insert astrologer details. astrol should contain keys:
  /// { 'User_ID': <userId>, 'Experience': 5, 'Specialization': 'Vedic', ... }
  Future<int> insertAstrologer(Map<String, dynamic> astrol) async {
    final db = await database;
    return await db.insert('astrologers', astrol);
  }

  /// Register an astrologer transactionally:
  /// Inserts into users then into astrologers (using the created user's id).
  /// Returns the inserted user id on success.
  Future<int> registerAstrologer({
    required Map<String, dynamic> user,
    required Map<String, dynamic> astrologer,
  }) async {
    final db = await database;
    return await db.transaction((txn) async {
      final userId = await txn.insert('users', user);
      // attach user_id to astrologer map
      final astMap = Map<String, dynamic>.from(astrologer);
      astMap['User_ID'] = userId;
      await txn.insert('astrologers', astMap);
      return userId;
    });
  }

  /// Authenticate user by email + password. Returns user row map or null.
  Future<Map<String, dynamic>?> authenticateUser(
    String email,
    String password,
  ) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'Email = ? AND Password = ?',
      whereArgs: [email, password],
    );
    return res.isNotEmpty ? res.first : null;
  }

  /// Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'Email = ?', whereArgs: [email]);
    return res.isNotEmpty ? res.first : null;
  }

  /// Fetch astrologer profile by user id (joins users + astrologers)
  Future<Map<String, dynamic>?> getAstrologerProfileByUserId(int userId) async {
    final db = await database;
    final res = await db.rawQuery(
      '''
      SELECT u.*, a.Astrologer_ID, a.Experience, a.Specialization, a.Bio, a.Qualifications, a.Rate_Per_Minute
      FROM users u
      LEFT JOIN astrologers a ON u.User_ID = a.User_ID
      WHERE u.User_ID = ?
    ''',
      [userId],
    );

    return res.isNotEmpty ? res.first : null;
  }

  /// Get all roles
  Future<List<Map<String, dynamic>>> getAllRoles() async {
    final db = await database;
    return await db.query('roles', orderBy: 'Role_ID');
  }

  /// Get all users (optionally by role id)
  Future<List<Map<String, dynamic>>> getAllUsers({int? roleId}) async {
    final db = await database;
    if (roleId != null) {
      return await db.query('users', where: 'Role_ID = ?', whereArgs: [roleId]);
    }
    return await db.query('users', orderBy: 'Created_At DESC');
  }

  /// Update user (supply a map with columns to update)
  Future<int> updateUser(int userId, Map<String, dynamic> values) async {
    final db = await database;
    return await db.update(
      'users',
      values,
      where: 'User_ID = ?',
      whereArgs: [userId],
    );
  }

  /// Update astrologer row by Astrologer_ID
  Future<int> updateAstrologer(
    int astrologerId,
    Map<String, dynamic> values,
  ) async {
    final db = await database;
    return await db.update(
      'astrologers',
      values,
      where: 'Astrologer_ID = ?',
      whereArgs: [astrologerId],
    );
  }

  /// Delete user (will cascade delete astrologer row because ON DELETE CASCADE)
  Future<int> deleteUser(int userId) async {
    final db = await database;
    return await db.delete('users', where: 'User_ID = ?', whereArgs: [userId]);
  }

  /// Convenience: check if email exists
  Future<bool> emailExists(String email) async {
    final db = await database;
    final res = await db.query(
      'users',
      columns: ['User_ID'],
      where: 'Email = ?',
      whereArgs: [email],
    );
    return res.isNotEmpty;
  }

  /// Close database
  Future close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
