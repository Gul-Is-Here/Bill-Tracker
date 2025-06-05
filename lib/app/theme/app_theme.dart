import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: const Color(0xFF4A6BFF),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4A6BFF),
      secondary: Color(0xFF6C5CE7),
      surface: Colors.white,
      background: Color(0xFFF5F5F5),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    cardColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF4A6BFF),
      titleTextStyle: GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFF6C5CE7),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6C5CE7),
      secondary: Color(0xFF00CEC9),
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white70,
      displayColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      titleTextStyle: GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}