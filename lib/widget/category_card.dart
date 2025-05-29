import 'dart:math';

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String image;
  final String label;

  const CategoryCard({super.key, required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      //fornisce un effetto visivo quando viene toccato
      onTap: () {
        //creazione ricetta
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/$image',
              fit: BoxFit.fill,
              height: screenHeight * 0.18,
              width: screenHeight * 0.18,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: screenHeight * 0.18,
            child: Text(label, style: TextStyle(fontSize: 17)),
          ),
        ],
      ),
    );
  }
}
