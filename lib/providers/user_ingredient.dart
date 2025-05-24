import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_coctails_bar/database/database_helper.dart';
import 'package:my_coctails_bar/models/ingredient.dart';
import 'package:sqflite/sqflite.dart';

class UserIngredientsNotifier extends StateNotifier<List<Ingredient>> {
  UserIngredientsNotifier() : super(const []) {
    fetchIngredients();
  }

  Future<void> fetchIngredients() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, Object?>> ingredientMaps = await db.query(
        'ingredients',
      );

      state = [
        for (final {
              'id': id as int,
              'nome': nome as String,
              'url': imageUrl as String,
            }
            in ingredientMaps)
          Ingredient.db(id: id, nome: nome, imageUrl: imageUrl),
      ];
    } catch (e) {
      state = [];
      rethrow;
    }
  }

  Future<void> addIngredient(Ingredient ingredient) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert(
      'ingredients',
      ingredient.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final updatedIngredient = ingredient.copyWith(id: id);

    state = [updatedIngredient, ...state];
  }

  Future<void> removeIngredient(Ingredient ingredient) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('ingredients', where: 'id = ?', whereArgs: [ingredient.id]);

    state = state.where((i) => i.id != ingredient.id).toList();
  }
}

final userIngredientsProvider =
    StateNotifierProvider<UserIngredientsNotifier, List<Ingredient>>(
      (ref) => UserIngredientsNotifier(),
    );
