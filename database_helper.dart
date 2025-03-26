import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Column names
  static const String columnId = 'id';
  static const String columnUsername = 'username';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUsername TEXT UNIQUE NOT NULL,
        $columnEmail TEXT UNIQUE NOT NULL,
        $columnPassword TEXT NOT NULL
      )
    ''');
  }

  Future<Map<String, dynamic>?> getUser(
    String username,
    String password,
  ) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: '$columnUsername = ? AND $columnPassword = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
