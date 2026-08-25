import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double _cardRadius = 12;

  // Helper method to get fonts with fallbacks
  static TextStyle _getPoppinsStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    ).copyWith(
      fontFamilyFallback: const ['Roboto', 'Arial', 'sans-serif'],
    );
  }

  static TextStyle _getRobotoStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    ).copyWith(
      fontFamilyFallback: const ['Arial', 'sans-serif'],
    );
  }

  // ---------- LIGHT THEME ----------
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.secondaryGreen,
        tertiary: AppColors.accentOrange,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: AppColors.backgroundLight,

      cardTheme: CardThemeData(
        elevation: 1,
        color: AppColors.surfaceLight,
        surfaceTintColor: AppColors.primaryBlue.withOpacity(0.05),
        shadowColor: Colors.black.withOpacity(0.08),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(
          horizontal: AppColors.spacingM,
          vertical: AppColors.spacingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
      ),

      textTheme: TextTheme(
        // Headings with Poppins
        displayLarge: _getPoppinsStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: _getPoppinsStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: _getPoppinsStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: _getPoppinsStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: _getPoppinsStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),

        // Body text with Roboto
        bodyLarge: _getRobotoStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: _getRobotoStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        bodySmall: _getRobotoStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_cardRadius),
          ),
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          textStyle: _getPoppinsStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(_cardRadius)),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        labelStyle: _getRobotoStyle(fontSize: 14),
        hintStyle: _getRobotoStyle(fontSize: 14, color: Colors.grey),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: _getPoppinsStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  // ---------- DARK THEME ----------
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryBlueLight,
        secondary: AppColors.secondaryGreenLight,
        tertiary: AppColors.accentOrangeLight,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: AppColors.backgroundDark,

      cardTheme: CardThemeData(
        elevation: 2,
        color: AppColors.surfaceDark,
        surfaceTintColor: AppColors.primaryBlueLight.withOpacity(0.1),
        shadowColor: Colors.black.withOpacity(0.4),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(
          horizontal: AppColors.spacingM,
          vertical: AppColors.spacingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
      ),

      textTheme: TextTheme(
        // Headings with Poppins
        displayLarge: _getPoppinsStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
        ),
        displayMedium: _getPoppinsStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
        ),
        displaySmall: _getPoppinsStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
        ),
        headlineMedium: _getPoppinsStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        titleLarge: _getPoppinsStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryDark,
        ),

        // Body text with Roboto
        bodyLarge: _getRobotoStyle(
          fontSize: 16,
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: _getRobotoStyle(
          fontSize: 14,
          color: AppColors.textSecondaryDark,
        ),
        bodySmall: _getRobotoStyle(
          fontSize: 12,
          color: AppColors.textSecondaryDark,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_cardRadius),
          ),
          backgroundColor: AppColors.primaryBlueLight,
          foregroundColor: Colors.white,
          textStyle: _getPoppinsStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(_cardRadius)),
          borderSide: BorderSide(color: AppColors.primaryBlueLight, width: 2),
        ),
        labelStyle: _getRobotoStyle(fontSize: 14, color: Colors.grey.shade300),
        hintStyle: _getRobotoStyle(fontSize: 14, color: Colors.grey.shade600),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: _getPoppinsStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
      ),
    );
  }
}