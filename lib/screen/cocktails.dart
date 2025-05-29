import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_coctails_bar/widget/category_card.dart';
import 'package:my_coctails_bar/widget/my_search_bar.dart';

class Cocktails extends StatefulWidget {
  const Cocktails({super.key});

  @override
  State<Cocktails> createState() => _CocktailsState();
}

class _CocktailsState extends State<Cocktails> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          MySearchBar(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Container(
              width: double.infinity,
              child: Text(
                'Select the category',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
            ),
          ),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              physics: NeverScrollableScrollPhysics(), // Disabilita lo scroll
              children: const [
                CategoryCard(image: 'dolce.jpeg', label: 'Sweet cocktail'),
                CategoryCard(image: 'amaro.jpg', label: 'bitter cocktail'),
                CategoryCard(image: 'shot.jpg', label: 'Shot'),
                CategoryCard(image: 'analcolico.jpg', label: 'mocktail'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
