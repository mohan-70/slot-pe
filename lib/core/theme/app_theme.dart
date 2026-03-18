import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      background: Color(0xFF05080F),
      surface: Color(0xFF0D1120),
      primary: Color(0xFF6366F1),
      secondary: Color(0xFF34D399),
      error: Color(0xFFF87171),
    ),
    scaffoldBackgroundColor: const Color(0xFF05080F),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF0D1120),
      titleTextStyle: GoogleFonts.syne(
        color: const Color(0xFFF0EDE8),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFF0D1120),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6366F1),
        textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.dmSans(color: const Color(0xFF6B7280)),
      hintStyle: GoogleFonts.dmSans(color: const Color(0xFF6B7280)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF6B7280)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF6366F1)),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFF87171)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFF87171)),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0D1120),
      selectedItemColor: Color(0xFF6366F1),
      unselectedItemColor: Color(0xFF6B7280),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.syne(color: const Color(0xFFF0EDE8), fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.syne(color: const Color(0xFFF0EDE8), fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.syne(color: const Color(0xFFF0EDE8), fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8), fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8), fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8), fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
      bodyMedium: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
      bodySmall: GoogleFonts.dmSans(color: const Color(0xFFF0EDE8)),
    ),
  );
}
