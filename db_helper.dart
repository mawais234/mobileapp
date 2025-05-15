import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const String dbName = 'students.db';
  static const String tableName = 'students';
  static const int dbVersion = 1;

  static Database? _database;

  // Initialize database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )''',
        );
      },
    );
  }

  // Add a new student
  static Future<int> addStudent(String name) async {
    final db = await database;
    return await db.insert(
      tableName,
      {
        'name': name,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  // Get all students
  static Future<List<Map<String, dynamic>>> getAllStudents() async {
    final db = await database;
    return await db.query(tableName, orderBy: 'id DESC');
  }

  // Delete a student
  static Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}