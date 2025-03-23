import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern to ensure only one instance of DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user.db'); // Database path
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, // Create the database table
    );
  }

  // Create the database table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        password TEXT
      )
    ''');
  }

  // Insert a user into the database
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  // Retrieve all users from the database
  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await database;
    return await db.query('users');
  }
}