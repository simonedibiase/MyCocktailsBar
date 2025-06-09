import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_coctails_bar/database/database_helper.dart';
import 'package:my_coctails_bar/models/cocktail.dart';
import 'package:my_coctails_bar/providers/fav_cocktail.dart';
import 'package:my_coctails_bar/screen/cocktail_screen.dart';
import 'package:my_coctails_bar/widget/coktail_tile.dart';
import 'package:my_coctails_bar/widget/header.dart';

class FavCocktail extends ConsumerWidget {
  const FavCocktail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cocktails = ref.watch(favoriteCocktailsProvider);

    void _removeCocktail(Cocktail cocktail) {
      ref.read(favoriteCocktailsProvider.notifier).removeCocktail(cocktail.id!);
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
                'Favorites cocktails',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800, // testo più grassetto
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            child:
                cocktails.isEmpty
                    ? const Center(
                      child: Text(
                        'There are no cocktails\n added to your favorites',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 148, 148, 148),
                        ),
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.all(15),
                      itemCount: cocktails.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 5),
                      itemBuilder: (context, index) {
                        final cocktail = cocktails[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CocktailTile(
                              key: ValueKey(cocktail.title),
                              cocktail: cocktail,
                              onRemove: () => _removeCocktail(cocktail),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
