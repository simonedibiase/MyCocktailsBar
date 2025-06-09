import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_coctails_bar/database/database_helper.dart';
import 'package:my_coctails_bar/models/cocktail.dart';
import 'package:my_coctails_bar/screen/cocktail_screen.dart';

class CocktailTile extends StatefulWidget {
  final Cocktail cocktail;
  final void Function() onRemove;

  const CocktailTile({
    super.key,
    required this.cocktail,
    required this.onRemove,
  });

  @override
  _CocktailTileState createState() => _CocktailTileState();
}

class _CocktailTileState extends State<CocktailTile>
    with SingleTickerProviderStateMixin {
  bool isFavorite = true;
  double opacity = 1.0;

  Timer? _removalTimer;

  @override
  void dispose() {
    _removalTimer?.cancel();
    super.dispose();
  }

  void _handleFavoriteToggle() {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (!isFavorite) {
      _removalTimer = Timer(const Duration(seconds: 3), () {
        setState(() {
          opacity = 0.0;
        });
      });
    } else {
      _removalTimer?.cancel();
      _removalTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: opacity,
      onEnd: () {
        if (opacity == 0) {
          Future.delayed(const Duration(milliseconds: 200), () {
            widget.onRemove();
          });
        }
      },
      child: ListTile(
        title: Text(
          widget.cocktail.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: 20,
            height: 2,
            letterSpacing: 0,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: _handleFavoriteToggle,
        ),
        onTap: () async {
          final ingredients = await DatabaseHelper.instance
              .getIngredientsForCocktail(widget.cocktail.id ?? 0);

          final cocktailMap = widget.cocktail.toMap();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => CocktailScreen(
                    cocktail: cocktailMap,
                    category: 'Favorites',
                  ),
            ),
          );
        },
      ),
    );
  }
}
