import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_coctails_bar/database/database_helper.dart';
import 'package:my_coctails_bar/models/cocktail.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteCocktailNotifier extends StateNotifier<List<Cocktail>> {
  FavoriteCocktailNotifier() : super(const []) {
    fetchCocktails();
  }

 Future<void> fetchCocktails() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final maps = await db.query('fav_cocktail');

      final cocktails = <Cocktail>[];

      for (final map in maps) {
        final title = map['title'] as String;
        final description = map['description'] as String;
        final ingredients = await DatabaseHelper.getIngredientsFavCocktail(
          title,
        );
        cocktails.add(
          Cocktail(
            title: title,
            description: description,
            ingredients: ingredients,
          ),
        );
      }
      state = cocktails;
    } catch (e) {
      state = [];
      rethrow;
    }
  }

  Future<void> addCocktail(Cocktail cocktail) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'fav_cocktail',
      cocktail.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    final existing = state.any((c) => c.title.toLowerCase() == cocktail.title.toLowerCase());

    if (!existing) {

      for (final ingredient in cocktail.ingredients) {
        final existingIngredient = await db.query(
          'fav_ingredients',
          where: 'id = ?',
          whereArgs: [ingredient.id],
        );

        if (existingIngredient.isEmpty) {
          await db.insert('fav_ingredients', {
            'id': ingredient.id,
            'nome': ingredient.nome,
            'url': ingredient.imageUrl,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }

        await db.insert('cocktail_ingredient', {
          'cocktail_title': cocktail.title,
          'ingredient_id': ingredient.id,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      state = [cocktail, ...state];
    }
  }

  Future<void> removeCocktail(String nome) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      'cocktail_ingredient',
      where: 'cocktail_title = ?',
      whereArgs: [nome],
    );
    await db.delete('fav_cocktail', where: 'title = ?', whereArgs: [nome]);

    final favIngredients = await db.query('fav_ingredients');

    for (final ingredient in favIngredients) {
      final ingredientId = ingredient['id'] as int;

      final references = await db.query(
        'cocktail_ingredient',
        where: 'ingredient_id = ?',
        whereArgs: [ingredientId],
      );

      if (references.isEmpty) {
        await db.delete(
          'fav_ingredients',
          where: 'id = ?',
          whereArgs: [ingredientId],
        );
      }
    }

    state = state.where((c) => c.title != nome).toList();
  }
}

final favoriteCocktailsProvider =
    StateNotifierProvider<FavoriteCocktailNotifier, List<Cocktail>>(
      (ref) => FavoriteCocktailNotifier(),
    );
