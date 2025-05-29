import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_coctails_bar/providers/user_ingredient.dart';
import 'package:my_coctails_bar/services/gemini.dart';

class CategoryCard extends ConsumerWidget {
  final String image;
  final String label;

  const CategoryCard({super.key, required this.image, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenHeight = MediaQuery.of(context).size.height;
    final ingredientsNotifier = ref.read(userIngredientsProvider.notifier);
    final ingredients = ref.watch(userIngredientsProvider);

    return InkWell(
      //fornisce un effetto visivo quando viene toccato
      onTap: () async {
        final gemini = Gemini();
        await gemini.initGemini();
        final ingredientNames =
            ingredients.map((ingredient) => ingredient.nome).toList();
        final ingredientString = ingredientNames.join(', ');
        var outputGemini = await gemini.getCocktail(ingredientString, label);
        print('****OUTPUT DI GEMINI: $outputGemini');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/$image',
              fit: BoxFit.fill,
              height: screenHeight * 0.18,
              width: screenHeight * 0.18,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: screenHeight * 0.18,
            child: Text(label, style: TextStyle(fontSize: 17)),
          ),
        ],
      ),
    );
  }
}
