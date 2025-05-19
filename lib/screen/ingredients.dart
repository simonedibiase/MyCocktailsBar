import 'package:flutter/material.dart';
import 'package:my_coctails_bar/screen/scanner.dart';
import 'package:my_coctails_bar/widget/my_search_bar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Ingredients extends StatefulWidget {
  const Ingredients({super.key});

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          MySearchBar(),
          Container(
            width: screenWidth * 0.9,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Available ingredients',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
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
