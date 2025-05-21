import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_coctails_bar/services/networking.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _MyState();
}

//class _ScannerPageState extends State<Scanner> with WidgetsBindingObserver {

class _MyState extends State<Scanner> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    String resultScanner = "";

    return Scaffold(
      appBar: AppBar(title: const Text("Barcode Scanner")),

      body: Stack(
        children: [
          MobileScanner(
            onDetect: (result) async {
              if (result.barcodes.first.rawValue != resultScanner) {
                resultScanner = result.barcodes.first.rawValue!;
                NetworkHelper networkHelper = NetworkHelper(
                  Uri.parse(
                    'https://world.openfoodfacts.org/api/v0/product/$resultScanner.json',
                  ),
                );
                var ingredientDeta = await networkHelper.getData();
                print(ingredientDeta);
              }
            },
            overlayBuilder: (context, constraints) {
              return Center(
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
