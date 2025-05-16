import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_coctails_bar/prova.dart';
import 'package:my_coctails_bar/screen/first_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromARGB(255, 255, 106, 0),
        scaffoldBackgroundColor: Colors.white,

        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          iconTheme: WidgetStateProperty.all(
            const IconThemeData(color: Color.fromARGB(255, 255, 106, 0)),
          ),
        ),

        textTheme: TextTheme(
          bodyLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
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
          
      ),
      home: MainScreen(),
    ),
  );
}
