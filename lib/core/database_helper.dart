import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'astro_life.db');
    return await openDatabase(
      path,
      // FIX: Database version incremented to 2 to trigger onUpgrade/onCreate
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Initial creation of the schema (for new installations)
  Future<void> _onCreate(Database db, int version) async {
    // Create the User table with ALL ERD columns
    await db.execute('''
      CREATE TABLE User (
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        middleName TEXT, 
        lastName TEXT,
        email TEXT UNIQUE,
        password TEXT,
        contact TEXT, 
        address TEXT, 
        birthDate TEXT,
        birthTime TEXT,
        gender TEXT,
        profilePictureUrl TEXT,
        isActive INTEGER,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    // Create the Roles table
    await db.execute('''
      CREATE TABLE Roles (
        roleId INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE,
        description TEXT,
        createdAt TEXT
      )
    ''');

    // Create the UserRoles join table
    await db.execute('''
      CREATE TABLE UserRoles (
        userId INTEGER,
        roleId INTEGER,
        FOREIGN KEY (userId) REFERENCES User(userId) ON DELETE CASCADE,
        FOREIGN KEY (roleId) REFERENCES Roles(roleId) ON DELETE CASCADE,
        PRIMARY KEY (userId, roleId)
      )
    ''');
  }

  // Logic to upgrade the schema (for existing installations)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Only handle the upgrade from v1 to v2 where we added columns
    if (oldVersion < 2) {
      // Add missing columns one by one
      if (oldVersion < 2) {
        // You only need to add columns that were missing in the old schema.
        await db.execute("ALTER TABLE User ADD COLUMN middleName TEXT;");
        await db.execute("ALTER TABLE User ADD COLUMN contact TEXT;");
        await db.execute("ALTER TABLE User ADD COLUMN address TEXT;");
      }
    }
  }
}
