import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: const Color(0xFFFA980B),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFA980B),
      secondary: Color(0xFF0BBEFA),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFF8FAFC),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    cardColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFFA980B),
      titleTextStyle: GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFFFA980B),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFA980B),
      secondary: Color(0xFF0BBEFA),
      surface: Color(0xFF1C2526),
      background: Color(0xFF0F1415),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F1415),
    cardColor: const Color(0xFF1C2526),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white70,
      displayColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1C2526),
      titleTextStyle: GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
