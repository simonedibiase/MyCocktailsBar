import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_coctails_bar/models/ingredient.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;
  //final VoidCallback? onDelete;

  const IngredientTile(this.ingredient, {/*this.onDelete,*/ super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLocalFile = ingredient.imageUrl.startsWith('/');
    final imageWidget = Image.file(
      File(ingredient.imageUrl),
      width: 70,
      height: 70,
    );

    return ListTile(
      leading: imageWidget,
      title: Text(
        ingredient.nome,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 18),
      ),
      /*trailing: IconButton(
        icon: const Icon(
          Icons.delete,
          color: Color.fromARGB(255, 196, 196, 196),
        ),
        onPressed: onDelete,
      ),*/
    );
  }
}
