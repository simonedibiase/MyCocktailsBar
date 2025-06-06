import 'dart:convert';

import 'package:my_coctails_bar/database/database_helper.dart';
import 'package:my_coctails_bar/models/ingredient.dart';

class Cocktail {
  final String title;
  final String description;
  final List<Ingredient> ingredients;

  Cocktail({
    required this.title,
    required this.description,
    required this.ingredients,
  });

  Map<String, Object?> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  static Future<Cocktail> fromMap(Map<String, Object?> map) async {
    return Cocktail(
      title: map['title'] as String,
      description: map['recipe'] as String,
      ingredients: await DatabaseHelper.getIngredientsFavCocktail(
        map['title'] as String,
      ),
    );
  }
}
