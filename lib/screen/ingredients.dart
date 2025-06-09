import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_coctails_bar/models/ingredient.dart';
import 'package:my_coctails_bar/providers/user_ingredient.dart';
import 'package:my_coctails_bar/screen/scanner.dart';
import 'package:my_coctails_bar/widget/ingredient_tile.dart';
import 'package:my_coctails_bar/widget/header.dart';

class Ingredients extends ConsumerWidget {
  const Ingredients({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final ingredients = ref.watch(userIngredientsProvider);
    final ingredientsNotifier = ref.read(userIngredientsProvider.notifier);

    void _removeIngredientWithUndo(Ingredient ingredient) {
      ingredientsNotifier.removeIngredient(ingredient);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          elevation: screenHeight * 0.5,
          content: Text(
            'Ingredient removed!',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          action: SnackBarAction(
            label: 'Cancel',
            onPressed: () {
              ingredientsNotifier.addIngredient(ingredient);
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Header(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Container(
              width: double.infinity,
              child: Text(
                'Available ingredients',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            child:
                ingredients.isEmpty
                    ? const Center(
                      child: Text(
                        'no ingredients present, \nadd some ingredients...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 148, 148, 148),
                        ),
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.all(15),
                      itemCount: ingredients.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final ingredient = ingredients[index];
                        return Dismissible(
                          key: ValueKey(ingredient.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _removeIngredientWithUndo(ingredient);
                          },
                          child: IngredientTile(
                            ingredient,
                            onDelete: () {
                              _removeIngredientWithUndo(ingredient);
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Scanner()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 255, 106, 0),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
