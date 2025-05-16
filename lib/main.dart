import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_coctails_bar/screen/first_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color.fromARGB(255, 255, 106, 0),
      scaffoldBackgroundColor: Colors.white,
    );

    final themedApp = baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme).copyWith(
        bodyLarge: GoogleFonts.poppins(
          fontSize: 38,
          fontWeight: FontWeight.w900,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        iconTheme: WidgetStateProperty.all(
          const IconThemeData(color: Color.fromARGB(255, 255, 106, 0)),
        ),
      ),

      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStateProperty.all(
          const Color.fromARGB(255, 255, 106, 0),
        ),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        hintStyle: WidgetStateProperty.all(
          GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white70,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );

    return MaterialApp(theme: themedApp, home: const FirstScreen());
  }
}
