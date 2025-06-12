import 'package:flutter/material.dart';
import 'package:my_coctails_bar/navigation/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key = const Key('first_screen')});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: (screenHeight / 1.7),
              child: Image.asset('assets/negroni4.jpg', fit: BoxFit.contain),
            ),
            Text(
              'It’s the cocktails\no’clock!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Scan your ingredients’ barcodes to get\nrecipes based on what you have",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.035),
            ElevatedButton(
              key: const Key('intro_forward_button'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Sfondo trasparente
                shadowColor: Colors.transparent, // Nessuna ombra
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isFirstTime', false);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ), //rimuove FirstScreen dallo stack
                );
              },
              child: const Icon(
                Icons.arrow_forward,
                size: 55,
                color: Color.fromARGB(255, 255, 106, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
