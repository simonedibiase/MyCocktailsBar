import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_coctails_bar/models/ingredient.dart';
import 'package:my_coctails_bar/providers/user_ingredient.dart';
import 'package:my_coctails_bar/services/gemini.dart';
import 'package:my_coctails_bar/widget/ingredient_tile.dart';

class Cocktail extends ConsumerStatefulWidget {
  const Cocktail({super.key, required this.cocktail, required this.category});
  final Map<String, dynamic> cocktail;
  final String category;

  @override
  ConsumerState<Cocktail> createState() => _CocktailState();
}

class _CocktailState extends ConsumerState<Cocktail> {
  var cocktail;
  bool isFavorite = false;
  String? category;
  List<Ingredient> completeIngredients = [];
  List<dynamic> cocktailList = [];

  get gemini => null;

  @override
  void initState() {
    super.initState();
    cocktail = widget.cocktail;
    cocktailList = [cocktail];
    loadIngredients();
  }

  Future<void> loadIngredients() async {
    final ingredients = await fetchIngredientsFromDb(cocktail['ingredients']);
    setState(() {
      completeIngredients = ingredients;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(cocktail);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final ingredients = ref.watch(userIngredientsProvider);
    final gemini = Gemini();

    return Scaffold(
      appBar: AppBar(title: const Text("My coktail")),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown, // Scala il testo solo se serve
                      alignment: Alignment.centerLeft,
                      child: Text(
                        cocktail['title'],
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 35,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Text('Ingridients (${cocktail['ingredients'].length})'),
              ...completeIngredients.map(
                (ingredient) => Column(
                  children: [
                    const SizedBox(height: 10),
                    IngredientTile(ingredient), // Spazio tra i Tile
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Recipe'),
              Text(
                cocktail['recipe'],
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  height: 2,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 0, bottom: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 106, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () async {
                  final gemini = Gemini();
                  await gemini.initGemini();

                  final ingredientNames =
                      ingredients.map((ingredient) => ingredient.nome).toList();
                  final ingredientString = ingredientNames.join(', ');
                  var outputGemini = await gemini.getNewCocktail(
                    ingredientString,
                    widget.category,
                    cocktailList,
                  );

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
                    final ingredientName =
                        ingredient['name']?.toString().toLowerCase();
                    return ingredients.any(
                      (userIng) => userIng.nome.toLowerCase() == ingredientName,
                    );
                  });

                  if (cocktailData['Error'] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 4),
                        content: Text(
                          'There are not enough ingredients to generate a new cocktail.\ntry entering more ingredients...',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    );
                  } else {
                    if (ingredientCeck) {
                      setState(() {
                        cocktail = cocktailData;
                        loadIngredients();
                        cocktailList.add(cocktailData);
                      });
                    } else {
                      Fluttertoast.showToast(
                        msg: "Sorry, there was an error.\nPlease try again..",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  }
                },

                child: Text(
                  'Generate a new ${widget.category.toLowerCase()} ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
