import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_coctails_bar/database/database_helper.dart';
import 'package:my_coctails_bar/models/ingredient.dart';
import 'package:my_coctails_bar/providers/fav_cocktail.dart';
import 'package:my_coctails_bar/providers/user_ingredient.dart';
import 'package:my_coctails_bar/services/gemini.dart';
import 'package:my_coctails_bar/widget/ingredient_tile.dart';
import 'package:my_coctails_bar/models/cocktail.dart';

class CocktailScreen extends ConsumerStatefulWidget {
  const CocktailScreen({
    super.key,
    required this.cocktail,
    required this.category,
  });
  final Map<String, dynamic> cocktail;
  final String category;

  @override
  ConsumerState<CocktailScreen> createState() => _CocktailScreenState();
}

class _CocktailScreenState extends ConsumerState<CocktailScreen> {
  var cocktail;
  bool isFavorite = false;
  String? category;
  List<Ingredient> completeIngredients = [];
  List<dynamic> cocktailList = [];
  bool isLoading = false;
  bool coktailSuccessivo = true;
  int? favoriteCocktailId;

  get gemini => null;

  @override
  void initState() {
    super.initState();
    cocktail = widget.cocktail;
    category = widget.category;
    cocktailList = [cocktail];

    if (category == 'Favorites') {
      isFavorite = true;
      favoriteCocktailId = cocktail['id'];
      completeIngredients =
          cocktail['ingredients']
              .map<Ingredient>(
                (ingredientMap) => Ingredient.fromMap(ingredientMap),
              )
              .toList();
      checkIfOnlyOneFavorite();
    } else {
      loadIngredients();
    }
  }

  Future<void> checkIfOnlyOneFavorite() async {
    final cocktails = await ref.read(favoriteCocktailsProvider);

    if (cocktails.length == 1) {
      setState(() {
        coktailSuccessivo = false;
      });
    }
  }

  Future<void> loadIngredients() async {
    final ingredients = await DatabaseHelper.instance.fetchIngredientsFromDb(
      cocktail['ingredients'],
    );
    setState(() {
      completeIngredients = ingredients;
    });
  }

  Future<Cocktail?> getNextCocktail(
    Cocktail currentCocktail,
    WidgetRef ref,
  ) async {
    final favorites = ref.read(favoriteCocktailsProvider);

    if (favorites.isEmpty) return null;

    final currentIndex = favorites.indexWhere(
      (c) => c.id == currentCocktail.id,
    );

    if (currentIndex + 1 >= favorites.length) {
      return favorites.first;
    }

    return favorites[currentIndex + 1];
  }

  @override
  Widget build(BuildContext context) {
    print(cocktail);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final ingredients = ref.watch(userIngredientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My coktail")),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 200.0),
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
                    icon:
                        isFavorite
                            ? Icon(Icons.favorite, color: Colors.red, size: 35)
                            : Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 35,
                            ),
                    onPressed: () async {
                      if (!isFavorite) {
                        final Cocktail newCocktail;
                        if (category == 'Favorites') {
                          newCocktail = await Cocktail.fromMap(cocktail);
                        } else {
                          newCocktail = await Cocktail.fromMapForGemini(
                            cocktail,
                          );
                        }

                        var id = await ref
                            .read(favoriteCocktailsProvider.notifier)
                            .addCocktail(newCocktail);
                        setState(() {
                          isFavorite = true;
                          favoriteCocktailId = id;
                        });
                      } else {
                        await ref
                            .read(favoriteCocktailsProvider.notifier)
                            .removeCocktail(favoriteCocktailId!);
                        setState(() {
                          isFavorite = false;
                          favoriteCocktailId = null;
                        });
                      }
                    },
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
      bottomSheet:
          coktailSuccessivo
              ? Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 10, bottom: 25),
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
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  if (category == 'Favorites') {
                                    await loadNextFavoriteCocktail();
                                  } else {
                                    await generateNewCocktailWithGemini(
                                      ingredients,
                                    );
                                  }
                                },
                        child:
                            isLoading
                                ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                                : Text(
                                  category == 'Favorites'
                                      ? 'Go to the next drink'
                                      : 'Generate a new ${widget.category.toLowerCase()}',
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
              )
              : SizedBox.shrink(), //widget che occupa spazio zero, non disegna nulla
    );
  }

  Future<void> loadNextFavoriteCocktail() async {
    setState(() => isLoading = true);

    final current = await Cocktail.fromMap(cocktail);
    final nextCocktail = await getNextCocktail(current, ref);

    if (nextCocktail == null) {
      setState(() => isLoading = false);
      Fluttertoast.showToast(msg: "No more cocktails found.");
      return;
    }

    setState(() {
      cocktail = nextCocktail.toMap();
      favoriteCocktailId = nextCocktail.id;
      completeIngredients = nextCocktail.ingredients;
      isFavorite = true;
      isLoading = false;
    });
  }

  Future<void> generateNewCocktailWithGemini(
    List<Ingredient> ingredients,
  ) async {
    setState(() => isLoading = true);

    final gemini = Gemini();
    await gemini.initGemini();

    final ingredientNames = ingredients.map((i) => i.nome).toList();
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
      cocktailIngredients = cocktailData['ingredients'] ?? [];
    } catch (e) {
      print('Errore nel parsing JSON: $e');
      cocktailData = {"Error": "Risposta non valida"};
    }

    bool ingredientCheck = cocktailIngredients.every((ingredient) {
      final ingredientName = ingredient['name']?.toString().toLowerCase();
      return ingredients.any(
        (userIng) => userIng.nome.toLowerCase() == ingredientName,
      );
    });

    if (cocktailData['Error'] != null) {
      coktailSuccessivo = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'There are not enough ingredients to generate a new cocktail.\nTry entering more ingredients...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    } else if (ingredientCheck) {
      setState(() {
        cocktail = cocktailData;
        loadIngredients();
        cocktailList.add(cocktailData);
        isFavorite = false;
      });
    } else {
      Fluttertoast.showToast(
        msg: "Sorry, there was an error.\nPlease try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    setState(() => isLoading = false);
  }
}
