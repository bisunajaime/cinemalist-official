import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Dark mode colors
  static const background = Color(0xFF0A0A0F);
  static const surface = Color(0xFF141419);
  static const card = Color(0xFF1C1C24);
  static const cardLight = Color(0xFF252530);
  static const primary = Color(0xFFD4A039);
  static const primaryLight = Color(0xFFF0C060);
  static const accent = Color(0xFFE8B84A);
  static const gold = Color(0xFFFFD700);
  static const amber = Color(0xFFFFB300);
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFF9E9E9E);
  static const textMuted = Color(0xFF616161);
  static const shimmerBase = Color(0xFF1C1C24);
  static const shimmerHighlight = Color(0xFF2A2A35);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFE53935);

  // Light mode colors
  static const lightBackground = Color(0xFFF5F5F8);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFEEEEF2);
  static const lightCardLight = Color(0xFFE0E0E6);
  static const lightPrimary = Color(0xFFB8860B);
  static const lightPrimaryLight = Color(0xFFD4A039);
  static const lightTextPrimary = Color(0xFF1A1A1F);
  static const lightTextSecondary = Color(0xFF5A5A65);
  static const lightTextMuted = Color(0xFF9E9EA5);
  static const lightShimmerBase = Color(0xFFE8E8EE);
  static const lightShimmerHighlight = Color(0xFFF5F5F8);

  static Color ratingColor(double rating) {
    if (rating >= 7.0) return success;
    if (rating >= 5.0) return warning;
    return error;
  }
}

extension AppColorsX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get background => isDark ? AppColors.background : AppColors.lightBackground;
  Color get surface => isDark ? AppColors.surface : AppColors.lightSurface;
  Color get cardColor => isDark ? AppColors.card : AppColors.lightCard;
  Color get cardLightColor => isDark ? AppColors.cardLight : AppColors.lightCardLight;
  Color get primaryColor => isDark ? AppColors.primary : AppColors.lightPrimary;
  Color get primaryLightColor => isDark ? AppColors.primaryLight : AppColors.lightPrimaryLight;
  Color get textPrimary => isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
  Color get textSecondary => isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;
  Color get textMuted => isDark ? AppColors.textMuted : AppColors.lightTextMuted;
  Color get shimmerBase => isDark ? AppColors.shimmerBase : AppColors.lightShimmerBase;
  Color get shimmerHighlight => isDark ? AppColors.shimmerHighlight : AppColors.lightShimmerHighlight;
}

class AppTheme {
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: _buildTextTheme(textTheme, AppColors.textPrimary, AppColors.textSecondary, AppColors.textMuted),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 9),
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.card,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerColor: AppColors.cardLight,
    );
  }

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.light().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightPrimaryLight,
        surface: AppColors.lightSurface,
        error: AppColors.error,
      ),
      textTheme: _buildTextTheme(textTheme, AppColors.lightTextPrimary, AppColors.lightTextSecondary, AppColors.lightTextMuted),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.lightTextMuted,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 9),
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCard,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2)),
        hintStyle: const TextStyle(color: AppColors.lightTextMuted),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightSurface,
        contentTextStyle: const TextStyle(color: AppColors.lightTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerColor: AppColors.lightCardLight,
    );
  }

  static TextTheme _buildTextTheme(TextTheme base, Color primary, Color secondary, Color muted) {
    return base.copyWith(
      headlineLarge: base.headlineLarge?.copyWith(color: primary, fontWeight: FontWeight.bold),
      headlineMedium: base.headlineMedium?.copyWith(color: primary, fontWeight: FontWeight.bold),
      titleLarge: base.titleLarge?.copyWith(color: primary, fontWeight: FontWeight.w600),
      titleMedium: base.titleMedium?.copyWith(color: primary, fontWeight: FontWeight.w500),
      bodyLarge: base.bodyLarge?.copyWith(color: primary),
      bodyMedium: base.bodyMedium?.copyWith(color: secondary),
      bodySmall: base.bodySmall?.copyWith(color: muted),
      labelLarge: base.labelLarge?.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.bold),
    );
  }
}

class AppRoutes {
  static Route<T> fade<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Route<T> slideUp<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 0.1), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}
