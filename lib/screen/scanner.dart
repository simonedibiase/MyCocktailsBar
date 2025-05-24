import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_coctails_bar/models/ingredient.dart';
import 'package:my_coctails_bar/services/networking.dart';
import 'package:my_coctails_bar/widget/ingredient_card.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _MyState();
}

class _MyState extends State<Scanner> {
  bool isDetecting = false;
  String resultScanner = "";
  bool recentlyScanned = false;

  void remove() {
    setState(() {
      isDetecting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    Ingredient ingredient = Ingredient(
      nome: 'Gin ',
      imageUrl: 'https://www.thecocktaildb.com/images/ingredients/gin.png',
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Barcode Scanner")),

      body: Stack(
        children: [
          MobileScanner(
            onDetect: (result) async {
              if (recentlyScanned) return;

              if (result.barcodes.first.rawValue != resultScanner) {
                recentlyScanned = true;
                resultScanner = result.barcodes.first.rawValue!;
                NetworkHelper networkHelper = NetworkHelper(
                  Uri.parse(
                    'https://world.openfoodfacts.org/api/v0/product/$resultScanner.json',
                  ),
                );
                final response = await networkHelper.getData();

                if (response['status'] == 1) {
                  setState(() {
                    isDetecting = true;
                  });
                } else {
                  setState(() {
                    isDetecting = false;
                  });
                  Fluttertoast.showToast(
                    msg: "sorry, product not recognized",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }

                await Future.delayed(Duration(seconds: 2));
                recentlyScanned = false;
              }
            },
            overlayBuilder: (context, constraints) {
              return Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.25,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              width: 3,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        const Text(
                          'Scan the barcode of \nthe product',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  if (isDetecting)
                    Positioned(
                      top: screenHeight * 0.65,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                      child: IngredientCard(ingredient, onDismiss: remove),
                    ),
                ],
              );
            },
            //errorBuilder: aggiungere un widget che segnala un errore in caso in cui non vi sono autorizzazioni,
            //da vedere nell'esempio
            placeholderBuilder:
                (context) => const Center(child: CircularProgressIndicator()),

            scanWindow: Rect.fromLTWH(
              (screenWidth - (screenWidth * 0.9)) / 2,
              (screenHeight - (screenHeight * 0.7)) / 2,
              screenWidth * 0.9,
              screenHeight * 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
