import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppConstants.primaryIndigo,
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      fontFamily: GoogleFonts.inter().fontFamily,
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppConstants.frostedGlass,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppConstants.accentTeal,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.white),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
        labelSmall: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
      ),
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.frostedGlass,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.inter(color: Colors.white54),
        labelStyle: GoogleFonts.inter(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppConstants.accentTeal, width: 2),
        ),
      ),
      
      // Text Selection Theme
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppConstants.accentTeal,
        selectionColor: AppConstants.accentTeal,
        selectionHandleColor: AppConstants.accentTeal,
      ),
      
      // ListTile Theme
      listTileTheme: ListTileThemeData(
        textColor: Colors.white,
        iconColor: Colors.white70,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          color: Colors.white,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1A1A1A),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}
