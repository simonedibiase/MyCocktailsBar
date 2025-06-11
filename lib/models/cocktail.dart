import 'dart:convert';

import 'package:my_coctails_bar/database/database_helper.dart';
import 'package:my_coctails_bar/models/ingredient.dart';

class Cocktail {
  final int? id;
  final String title;
  final String description;
  final List<Ingredient> ingredients;

  Cocktail({
    this.id,
    required this.title,
    required this.description,
    required this.ingredients,
  });

  Map<String, Object?> toMapSmall() {
    return {'title': title, 'description': description};
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'recipe': description,
      'ingredients':
          ingredients
              .map((i) => {'id': i.id, 'nome': i.nome, 'url': i.imageUrl})
              .toList(),
    };
  }

  static Future<Cocktail> fromMapForGemini(Map<String, Object?> map) async {
    return Cocktail(
      title: map['title'] as String,
      description: map['recipe'] as String,
      ingredients: await DatabaseHelper.getMatchingIngredientstFromIngredient(
        (map['ingredients'] as List)
            .map((e) => Map<String, String>.from(e as Map))
            .toList(),
      ),
    );
  }

  static Cocktail fromMap (Map<String, dynamic> map) {
    return Cocktail(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['recipe'] as String,
      ingredients:
          (map['ingredients'] as List<dynamic>)
              .map((item) => Ingredient.fromMap(item as Map<String, dynamic>))
              .toList(),
    );
  }

  

  Cocktail copyWith({
    int? id,
    String? title,
    String? description,
    List<Ingredient>? ingredients,
  }) {
    return Cocktail(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}
