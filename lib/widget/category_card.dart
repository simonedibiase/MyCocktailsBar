import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_coctails_bar/providers/user_ingredient.dart';
import 'package:my_coctails_bar/screen/category.dart';
import 'package:my_coctails_bar/screen/cocktail_screen.dart';
import 'package:my_coctails_bar/services/gemini.dart';

class CategoryCard extends ConsumerWidget {
  final String image;
  final String label;
  final bool isLoading;
  final Function(bool) onLoadingChanged;

  const CategoryCard({
    super.key,
    required this.image,
    required this.label,
    required this.isLoading,
    required this.onLoadingChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenHeight = MediaQuery.of(context).size.height;
    final ingredients = ref.watch(userIngredientsProvider);

    return InkWell(
      //fornisce un effetto visivo quando viene toccato
      onTap: () async {
        onLoadingChanged(true);

        final gemini = Gemini();
        await gemini.initGemini();

        final ingredientNames =
            ingredients.map((ingredient) => ingredient.nome).toList();
        final ingredientString = ingredientNames.join(', ');
        var outputGemini = await gemini.getCocktail(ingredientString, label);

        Map<String, dynamic> cocktailData = {};
        List<dynamic> cocktailIngredients = [];

        try {
          cocktailData = jsonDecode(outputGemini.text ?? '{}');
          cocktailIngredients =
              cocktailData['ingredients'] as List<dynamic>? ?? [];
        } catch (e) {
          print('Errore nel parsing JSON: $e');
          cocktailData = {"Error": "Risposta non valida"};
        }

        bool ingredientCeck = cocktailIngredients.every((ingredient) {
          final ingredientName = ingredient['name']?.toString().toLowerCase();
          return ingredients.any(
            (userIng) => userIng.nome.toLowerCase() == ingredientName,
          );
        });

        if (cocktailData['Error'] != null) {
          Fluttertoast.showToast(
            msg:
                "sorry, not enough ingredients.\n Try adding more ingredients...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          if (ingredientCeck) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        CocktailScreen(cocktail: cocktailData, category: label),
              ),
            );
          } else {
            Fluttertoast.showToast(
              msg: "Sorry, there was an error.\nPlease try again..",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        }
        onLoadingChanged(false);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/$image',
              fit: BoxFit.fill,
              height: screenHeight * 0.19,
              width: screenHeight * 0.19,
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          SizedBox(
            width: screenHeight * 0.18,
            child: Text(label, style: TextStyle(fontSize: 17)),
          ),
        ],
      ),
    );
  }
}
