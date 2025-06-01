import 'package:my_coctails_bar/models/ingredient.dart';

class Cocktail {
  final int? id;
  final String? error;
  final String title;
  final String description;
  final List<Ingredient> ingredients;

  Cocktail(Map<String, dynamic> cocktailData, {
    required this.id,
    this.error,
    required this.title,
    required this.description,
    required this.ingredients,
  });

  Map<String, Object?> toMap() {
    return {
      'error ': error,
      'title': title,
      'description': description,
      'ingredients' : ingredients,
    };
  }
}
