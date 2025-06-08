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
        final ingredients = await DatabaseHelper.instance
            .getIngredientsForCocktail(map['id'] as int);

        final id = map['id'] as int;
        cocktails.add(
          Cocktail(
            id: id,
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

  Future<int> addCocktail(Cocktail cocktail) async {
    final db = await DatabaseHelper.instance.database;

    final cocktailId = await db.insert(
      'fav_cocktail',
      cocktail.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    if (cocktailId == 0) {
      return 0;
    }

    final updatedCocktail = cocktail.copyWith(id: cocktailId);

    for (final ingredient in cocktail.ingredients) {
      await db.insert('fav_ingredients', {
        'id': ingredient.id,
        'nome': ingredient.nome,
        'url': ingredient.imageUrl,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      await db.insert('cocktail_ingredient', {
        'cocktail_id': cocktailId,
        'ingredient_id': ingredient.id,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    state = [updatedCocktail, ...state];
    return cocktailId;
  }

  Future<void> removeCocktail(int id) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      'cocktail_ingredient',
      where: 'cocktail_id = ?',
      whereArgs: [id],
    );
    await db.delete('fav_cocktail', where: 'id = ?', whereArgs: [id]);

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

    state = state.where((c) => c.id != id).toList();
  }
}

final favoriteCocktailsProvider =
    StateNotifierProvider<FavoriteCocktailNotifier, List<Cocktail>>(
      (ref) => FavoriteCocktailNotifier(),
    );
