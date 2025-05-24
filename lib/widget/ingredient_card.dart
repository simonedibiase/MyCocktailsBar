import 'package:flutter/material.dart';
import 'package:my_coctails_bar/models/ingredient.dart';
import 'package:auto_size_text/auto_size_text.dart';

class IngredientCard extends StatefulWidget {
  const IngredientCard(this.ingredient, {required this.onDismiss, super.key});

  final Ingredient ingredient;
  final Function() onDismiss;

  @override
  State<IngredientCard> createState() => _IngredientItemState();
}

class _IngredientItemState extends State<IngredientCard> {
  bool _isAdded = false;
  bool _isVisible = true;

  void _handleAdd() async {
    setState(() {
      _isAdded = true; //mette la spunta verde
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isVisible = false; //diventa trasparente
    });

    await Future.delayed(Duration(milliseconds: 300));
    widget.onDismiss(); //elimina il widget
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
            SizedBox(
              width: screenWidth * 0.45,
              child: AutoSizeText(widget.ingredient.nome),
            ),
            const Spacer(),
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
