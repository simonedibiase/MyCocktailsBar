import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_coctails_bar/providers/user_ingredient.dart';
import 'package:my_coctails_bar/widget/category_card.dart';
import 'package:my_coctails_bar/widget/header.dart';

class Category extends ConsumerStatefulWidget  {
  const Category({super.key});

  @override
  ConsumerState<Category> createState() => _CategoryState();
}

class _CategoryState extends ConsumerState<Category> {
  bool isLoading = false;

  handleLoadingChanged(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final ingredients = ref.watch(userIngredientsProvider);
    final ingredientsNotifier = ref.read(userIngredientsProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          Header(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Container(
              width: double.infinity,
              child: Stack(
                children: [
                  Text(
                    'Select the category',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (ingredients.isEmpty)
                    Positioned.fill(
                      child: Container(
                        color: const Color.fromARGB(200, 255, 255, 255),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Stack(
              children: [
                // Griglia delle categorie
                GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 1.95,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CategoryCard(image: 'dolce.jpeg', label: 'Sweet cocktail', 
                      isLoading: false, onLoadingChanged: handleLoadingChanged,
                    ),
                    CategoryCard(image: 'amaro.jpg', label: 'Bitter cocktail', isLoading: false,
                      onLoadingChanged: handleLoadingChanged,
                    ),
                    CategoryCard(image: 'shot.jpg', label: 'Shot', isLoading: false,
                      onLoadingChanged: handleLoadingChanged,
                    ),
                    CategoryCard(image: 'analcolico.jpg', label: 'Mocktail', isLoading: false,
                      onLoadingChanged: handleLoadingChanged,
                    ),
                  ],
                ),

                // Layer grigio se ingredients è vuoto
                if (ingredients.isEmpty)
                  Container(color: const Color.fromARGB(200, 255, 255, 255)),

                 if (isLoading)
                  Container(
                    color: const Color.fromARGB(200, 255, 255, 255),
                    child: const Center(
                      child: CircularProgressIndicator(color: Color.fromARGB(255, 255, 106, 0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],      
      ),
     
    );
  }
}
