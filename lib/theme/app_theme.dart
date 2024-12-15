import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final Color _primaryColorLight = Colors.blue;
  static final Color _primaryColorDark = Colors.blue.shade200;

  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.lato(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.lato(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.lato(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _primaryColorLight,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: _primaryColorLight,
        secondary: Colors.blueAccent,
        surface: Colors.white,
        background: Colors.grey[50]!,
      ),
      textTheme: _textTheme,
      iconTheme: const IconThemeData(color: Colors.black87),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _primaryColorDark,
      scaffoldBackgroundColor: Colors.grey[900],
      cardColor: Colors.grey[850],
      colorScheme: ColorScheme.dark(
        primary: _primaryColorDark,
        secondary: Colors.blueAccent,
        surface: Colors.grey[850]!,
        background: Colors.grey[900]!,
      ),
      textTheme: _textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
