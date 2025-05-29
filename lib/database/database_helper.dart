import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateCostructor();
  static Database? _database;

  DatabaseHelper._privateCostructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cocktails.db');

    return await openDatabase(
      path,
      version: 7,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS ingredients (
            id INTEGER PRIMARY KEY,
            nome TEXT,
            url TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS fav_cocktails (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            recipe TEXT,
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS fav_ingredients (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            recipe_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            url TEXT,
            FOREIGN KEY (recipe_id) REFERENCES fav_recipes (id) on DELETE CASCADE
          )
        ''');
      },
    );
  }
}
