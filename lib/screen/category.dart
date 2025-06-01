import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_coctails_bar/providers/user_ingredient.dart';
import 'package:my_coctails_bar/widget/category_card.dart';
import 'package:my_coctails_bar/widget/my_search_bar.dart';

class Category extends ConsumerWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final ingredients = ref.watch(userIngredientsProvider);
    final ingredientsNotifier = ref.read(userIngredientsProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          MySearchBar(),

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
                  children: const [
                    CategoryCard(image: 'dolce.jpeg', label: 'Sweet cocktail'),
                    CategoryCard(image: 'amaro.jpg', label: 'Bitter cocktail'),
                    CategoryCard(image: 'shot.jpg', label: 'Shot'),
                    CategoryCard(image: 'analcolico.jpg', label: 'Mocktail'),
                  ],
                ),

                // Layer grigio se ingredients è vuoto
                if (ingredients.isEmpty)
                  Container(color: const Color.fromARGB(200, 255, 255, 255)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
