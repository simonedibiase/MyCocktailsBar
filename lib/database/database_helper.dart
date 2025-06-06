import 'package:my_coctails_bar/models/ingredient.dart';
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
      version: 100,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS ingredients (
            id INTEGER PRIMARY KEY,
            nome TEXT,
            url TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS fav_ingredients (
            id INTEGER PRIMARY KEY,
            nome TEXT,
            url TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS fav_cocktail (
            title TEXT PRIMARY KEY,
            description TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS cocktail_ingredient (
            cocktail_title TEXT,
            ingredient_id INTEGER,
            FOREIGN KEY (cocktail_title) REFERENCES fav_cocktail(title),
            FOREIGN KEY (ingredient_id) REFERENCES fav_ingredients(id),
            PRIMARY KEY (cocktail_title, ingredient_id)
          )
        ''');
      },
    );
  }

  Future<List<Ingredient>> fetchIngredientsFromDb(List<dynamic> names) async {
    final db = await DatabaseHelper.instance.database;

    List<Ingredient> completeIngredients = [];

    for (var ingredient in names) {
      if (ingredient.containsKey('name')) {
        final name = (ingredient['name'] as String).toLowerCase().trim();

        final result = await db.query(
          'ingredients',
          where: 'LOWER(TRIM(nome)) = ?',
          whereArgs: [name],
        );

        if (result.isNotEmpty) {
          completeIngredients.add(Ingredient.fromMap(result.first));
        }
      }
    }
    return completeIngredients;
  }

  static Future<List<Ingredient>> getIngredientsFavCocktail(
    String title,
  ) async {
    final db = await instance.database;
    final results = await db.rawQuery(
      '''
      SELECT fav_ingredients.*
      FROM fav_ingredients
      JOIN cocktail_ingredient ON fav_ingredients.id = cocktail_ingredient.ingredient_id
      WHERE cocktail_ingredient.cocktail_title = ?
    ''',
      [title],
    );

    return results.map((map) => Ingredient.fromMap(map)).toList();
  }
}
