import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_coctails_bar/navigation/main_screen.dart';
import 'package:my_coctails_bar/screen/first_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(ProviderScope(child: MyApp(isFirstTime: isFirstTime)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isFirstTime});

  final bool isFirstTime;

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

      appBarTheme: AppBarTheme(
        backgroundColor: baseTheme.primaryColor,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 25,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themedApp,
      home: isFirstTime ? const FirstScreen() : const MainScreen(),
    );
  }
}
