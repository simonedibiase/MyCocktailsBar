import 'package:flutter/material.dart';
import 'package:my_coctails_bar/navigation/main_screen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1.7,
              child: Image.asset('assets/negroni4.jpg', fit: BoxFit.contain),
            ),
            Text(
              'It’s the cocktails\no’clock!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text(
              'Discover refined recipes based on \nyour available ingredients',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Sfondo trasparente
                shadowColor: Colors.transparent, // Nessuna ombra
                elevation: 0, // Nessuna elevazione
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
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
