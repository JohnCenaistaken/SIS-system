import 'package:flutter/material.dart';

/// App color constants following Material Design 3 guidelines
class AppColors {
  AppColors._();

  // Primary Colors - Blue for trust/calm
  static const Color primaryBlue = Color(0xFF1A56DB);
  static const Color primaryBlueLight = Color(0xFF4A7FE8);
  static const Color primaryBlueDark = Color(0xFF0F3A9E);

  // Secondary Colors - Green for growth
  static const Color secondaryGreen = Color(0xFF10B981);
  static const Color secondaryGreenLight = Color(0xFF34D399);
  static const Color secondaryGreenDark = Color(0xFF059669);

  // Accent Colors - Orange for alerts
  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentOrangeLight = Color(0xFFFBBF24);
  static const Color accentOrangeDark = Color(0xFFD97706);

  // Legacy accent
  static const Color accentColor = accentOrange;
  static const Color accentLight = accentOrangeLight;
  static const Color accentDark = accentOrangeDark;

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textPrimaryDark = Color(0xFFE5E7EB);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Status Colors
  static const Color success = secondaryGreen;
  static const Color warning = accentOrange;
  static const Color error = Color(0xFFEF4444);
  static const Color info = primaryBlue;

  // Priority Colors
  static const Color urgent = Color(0xFFEF4444);
  static const Color important = Color(0xFFF59E0B);
  static const Color normal = Color(0xFF3B82F6);

  // Spacing Constants
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Gradients - Now inside the class
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueLight], // No need for AppColors. prefix
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      primaryBlue,
      primaryBlueLight,
      Color(0xFF60A5FA),
    ],
  );
}