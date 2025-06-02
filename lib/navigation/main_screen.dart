import 'package:flutter/material.dart';
import 'package:my_coctails_bar/screen/category.dart';
import 'package:my_coctails_bar/screen/ingredients.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          height: MediaQuery.of(context).size.height * 0.075,
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.local_bar),
              label: 'Cocktail',
            ),
            NavigationDestination(
              icon: Icon(Icons.list_alt),
              label: 'Ingredients',
            ),
          ],
        ),
        body: [Category(), Ingredients()][currentPageIndex],
    );
  }
}
