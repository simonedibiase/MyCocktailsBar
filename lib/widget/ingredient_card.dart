import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_coctails_bar/models/ingredient.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:my_coctails_bar/providers/user_ingredient.dart';
import 'package:my_coctails_bar/services/dowload_and_save_image.dart';

class IngredientCard extends ConsumerStatefulWidget {
  const IngredientCard(this.ingredient, {required this.onDismiss, super.key});

  final Ingredient ingredient;
  final Function() onDismiss;

  @override
  ConsumerState<IngredientCard> createState() => _IngredientItemState();
}

class _IngredientItemState extends ConsumerState<IngredientCard> {
  bool _isAdded = false;
  bool _isVisible = true;
  bool _alreadyExist = false;

  void _handleAdd() async {
    setState(() {
      _isAdded = true; //mette la spunta verde
    });

    final localPath = await downloadAndSaveImage(
      widget.ingredient.imageUrl,
      widget.ingredient.nome,
    );

    final localIngredient = Ingredient(
      id: widget.ingredient.id,
      nome: widget.ingredient.nome,
      imageUrl: localPath ?? widget.ingredient.imageUrl,
    );

    try {
      await ref
          .read(userIngredientsProvider.notifier)
          .addIngredient(localIngredient);
    } catch (e) {
      _alreadyExist = true;
    }

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isVisible = false; //diventa trasparente
    });

    await Future.delayed(Duration(milliseconds: 300));
    widget.onDismiss(); //elimina il widget

    if (_alreadyExist) {
      Fluttertoast.showToast(
        msg: "the product is already present",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: const Color.fromARGB(255, 255, 255, 255),
        fontSize: 16.0,
      );
      _alreadyExist = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.02,
        ),
        height: screenHeight * 0.13,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          children: [
            Image.network(
              widget.ingredient.imageUrl,
              width: screenHeight * 0.10,
              height: screenHeight * 0.10,
            ),
            Expanded(
              child: AutoSizeText(
                widget.ingredient.nome,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //const Spacer(),
            FloatingActionButton(
              onPressed: _handleAdd,
              backgroundColor:
                  _isAdded ? Colors.green : Color.fromARGB(255, 255, 106, 0),
              child: Icon(
                _isAdded ? Icons.check : Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
