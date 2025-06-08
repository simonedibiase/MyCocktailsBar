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
      version: 105,
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
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS cocktail_ingredient (
            cocktail_id INTEGER,
            ingredient_id INTEGER,
            FOREIGN KEY (cocktail_id) REFERENCES fav_cocktail(id),
            FOREIGN KEY (ingredient_id) REFERENCES fav_ingredients(id),
            PRIMARY KEY (cocktail_id, ingredient_id)
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

  static Future<List<Ingredient>> getMatchingIngredientstFromIngredient(
    List<Map<String, String>> ingredientsList,
  ) async {
    final db = await instance.database;
    List<Ingredient> matchedIngredients = [];

    for (final ingredient in ingredientsList) {
      final name = ingredient['name']!.toLowerCase().trim();

      final result = await db.query(
        'ingredients',
        where: 'LOWER(TRIM(nome)) = ?',
        whereArgs: [name],
      );

      if (result.isNotEmpty) {
        matchedIngredients.add(Ingredient.fromMap(result.first));
      }
    }

    return matchedIngredients;
  }

  Future<List<Ingredient>> getIngredientsForCocktail(int cocktailId) async {
    final db = await database;

    // Trova tutti gli ingredient_id associati al cocktailId
    final ingredientLinks = await db.query(
      'cocktail_ingredient',
      where: 'cocktail_id = ?',
      whereArgs: [cocktailId],
    );

    List<Ingredient> ingredients = [];

    for (final link in ingredientLinks) {
      final ingredientId = link['ingredient_id'] as int;

      // Recupera l'ingrediente completo dalla tabella fav_ingredients
      final result = await db.query(
        'fav_ingredients',
        where: 'id = ?',
        whereArgs: [ingredientId],
      );

      if (result.isNotEmpty) {
        ingredients.add(Ingredient.fromMap(result.first));
      }
    }

    return ingredients;
  }
}
