import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Exact colors from the screenshots
  static const Color primary = Color(0xFF2111D4);
  static const Color backgroundDark = Color(0xFF121022);
  static const Color surfaceDark = Color(0xFF1E1B33);
  static const Color cardDark = Color(0xFF1A172E);
  
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  static const Color amber400 = Color(0xFFFBBF24);
  static const Color red500 = Color(0xFFEF4444);
  static const Color green500 = Color(0xFF22C55E);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        surface: backgroundDark,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white),
        bodyMedium: GoogleFonts.inter(color: Colors.white70),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF121022),
        selectedItemColor: primary,
        unselectedItemColor: slate500,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: primary,
        contentTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
