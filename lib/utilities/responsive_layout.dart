import 'package:flutter/material.dart';

/// Responsive layout utilities for different screen sizes
class ResponsiveLayout {
  ResponsiveLayout._();

  /// Breakpoints for different screen sizes
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0);
    }
  }

  /// Get responsive font size multiplier
  static double getFontMultiplier(BuildContext context) {
    if (isMobile(context)) {
      return 1.0;
    } else if (isTablet(context)) {
      return 1.2;
    } else {
      return 1.4;
    }
  }

  /// Get responsive card width
  static double getCardWidth(BuildContext context, {int columns = 2}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = getResponsivePadding(context).horizontal;
    final availableWidth = screenWidth - padding;
    
    if (isMobile(context)) {
      return availableWidth;
    } else {
      return (availableWidth - (columns - 1) * 16) / columns;
    }
  }
}

/// Mixin for responsive widgets
mixin ResponsiveMixin {
  bool isMobile(BuildContext context) => ResponsiveLayout.isMobile(context);
  bool isTablet(BuildContext context) => ResponsiveLayout.isTablet(context);
  bool isDesktop(BuildContext context) => ResponsiveLayout.isDesktop(context);
}
