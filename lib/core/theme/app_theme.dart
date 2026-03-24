import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light(
      primary: AppConstants.primaryIndigo,
      onPrimary: Colors.white,
      secondary: AppConstants.accentTeal,
      onSecondary: Colors.white,
      tertiary: AppConstants.lavender,
      onTertiary: Colors.white,
      surface: Colors.white,
      onSurface: AppConstants.textPrimary,
      background: Color(0xFFF7F7FB),
      onBackground: AppConstants.textPrimary,
      outline: Color(0xFFE1E3EA),
      surfaceVariant: AppConstants.surfaceMuted,
      onSurfaceVariant: AppConstants.textSecondary,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      primaryColor: AppConstants.primaryIndigo,
      scaffoldBackgroundColor: colorScheme.background,
      fontFamily: GoogleFonts.inter().fontFamily,

      // Card Theme
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppConstants.accentTeal,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onBackground,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: colorScheme.onBackground,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onBackground),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onBackground,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.frostedGlass,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        hintStyle: GoogleFonts.inter(color: colorScheme.onSurfaceVariant),
        labelStyle: GoogleFonts.inter(color: colorScheme.onSurfaceVariant),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
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

      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppConstants.frostedGlass,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
        ),
      ),

      // ListTile Theme
      listTileTheme: ListTileThemeData(
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.primary,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppConstants.frostedGlass,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: colorScheme.onSurface,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      dividerTheme: DividerThemeData(color: colorScheme.outline, thickness: 1),

      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.secondary;
          }
          return colorScheme.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.secondary.withOpacity(0.35);
          }
          return colorScheme.surfaceVariant;
        }),
      ),

      expansionTileTheme: ExpansionTileThemeData(
        iconColor: colorScheme.primary,
        collapsedIconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        collapsedTextColor: colorScheme.onSurfaceVariant,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.onSurface,
        contentTextStyle: GoogleFonts.inter(color: colorScheme.surface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.surface;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return colorScheme.onPrimary;
            }
            return colorScheme.onSurfaceVariant;
          }),
          side: MaterialStateProperty.all(
            BorderSide(color: colorScheme.outline),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      primary: AppConstants.accentTeal,
      onPrimary: Color(0xFF041221),
      secondary: AppConstants.lavender,
      onSecondary: Colors.white,
      tertiary: AppConstants.primaryIndigo,
      onTertiary: Colors.white,
      surface: Color(0xFF161B29),
      onSurface: Colors.white,
      background: Color(0xFF0D111D),
      onBackground: Colors.white,
      outline: Color(0xFF2B3145),
      surfaceVariant: Color(0xFF1F2535),
      onSurfaceVariant: Color(0xFF9BA5C1),
      error: Color(0xFFEF5350),
      onError: Colors.white,
    );

    final baseTextColor = colorScheme.onBackground;
    final mutedTextColor = colorScheme.onSurfaceVariant;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      primaryColor: colorScheme.primary,
      fontFamily: GoogleFonts.inter().fontFamily,

      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: baseTextColor,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: baseTextColor,
        ),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: baseTextColor),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: mutedTextColor),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: mutedTextColor),
        labelSmall: GoogleFonts.inter(fontSize: 12, color: mutedTextColor),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: baseTextColor),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: baseTextColor,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        hintStyle: GoogleFonts.inter(color: mutedTextColor),
        labelStyle: GoogleFonts.inter(color: mutedTextColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withOpacity(0.4),
        selectionHandleColor: colorScheme.primary,
      ),

      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
        ),
      ),

      listTileTheme: ListTileThemeData(
        textColor: baseTextColor,
        iconColor: colorScheme.primary,
        titleTextStyle: GoogleFonts.inter(fontSize: 16, color: baseTextColor),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: mutedTextColor,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: GoogleFonts.inter(fontSize: 12, color: baseTextColor),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: mutedTextColor,
        ),
      ),

      dividerTheme: DividerThemeData(color: colorScheme.outline, thickness: 1),

      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary.withOpacity(0.45);
          }
          return colorScheme.surfaceVariant;
        }),
      ),

      expansionTileTheme: ExpansionTileThemeData(
        iconColor: colorScheme.primary,
        collapsedIconColor: mutedTextColor,
        textColor: baseTextColor,
        collapsedTextColor: mutedTextColor,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: baseTextColor,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: mutedTextColor,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surface,
        contentTextStyle: GoogleFonts.inter(color: baseTextColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return colorScheme.primary;
            }
            return colorScheme.surface;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return colorScheme.onPrimary;
            }
            return mutedTextColor;
          }),
          side: MaterialStateProperty.all(
            BorderSide(color: colorScheme.outline),
          ),
        ),
      ),
    );
  }
}
