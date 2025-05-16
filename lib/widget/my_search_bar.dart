import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double heightBox = (MediaQuery.of(context).size.height * 0.4);
    return SizedBox(
      width: double.infinity,
      height: heightBox,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(50.0),
              bottomLeft: Radius.circular(50.0),
            ),
            child: Image.asset(
              'assets/sfondo1.png',
              height: heightBox * 0.84,
              width: double.infinity,
              fit: BoxFit.cover, //riempie completamente lo spazio disponibile
            ),
          ),
          Positioned(
            top: heightBox * 0.25,
            left: 0,
            right: 0,
            child: Text(
              'What do you want\n to cook today?',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: heightBox * 0.73,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: SearchAnchor(
                builder: (context, controller) {
                  return SearchBar(
                    /* backgroundColor: WidgetStateProperty.all(
                      Color.fromARGB(255, 255, 106, 0),
                    ),
                    textStyle: WidgetStateProperty.all(
                      TextStyle(color: Colors.white),
                    ),*/
                    hintText: 'Search the ingredient',
                    leading: Icon(Icons.search, color: Colors.white),
                    onChanged: (query) {
                      // filtrare
                    },
                  );
                },
                suggestionsBuilder: (context, controller) {
                  return [];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
