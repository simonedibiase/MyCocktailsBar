import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              'It’s the cocktails\no’clock',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white, height: 1.2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text(
              'Discover refined recipes based on \nyour available ingredients',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                height: 1.2,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 106, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 75,
                  vertical: 10,
                ),
              ),
              onPressed: () {},
              child: Text(
                'Start',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
