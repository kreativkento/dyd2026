import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  // Brand palette — red is dominant
  static const primary = Color(0xFFB91921);
  static const primaryDark = Color(0xFF8E1218);
  static const green = Color(0xFF2D8845);
  static const blue = Color(0xFF046DAE);
  static const yellow = Color(0xFFF4BF02);

  // Legacy aliases used across the app
  static const accent = yellow;
  static const accentLight = Color(0xFFFFF3C2);

  // Neutrals
  static const surface = Colors.white;
  static const card = Colors.white;
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF666666);
  static const emergency = primary;
}

/// Shared layout metrics for root tab screens (below [AppTitleBanner]).
abstract final class AppLayout {
  static const tabHorizontalPadding = 16.0;

  static const tabContentPadding = EdgeInsets.all(tabHorizontalPadding);

  /// Extra inset for tab titles/subtitles (on top of [tabHorizontalPadding]).
  static const sectionHeaderHorizontalInset = 4.0;

  static const sectionHeaderPadding = EdgeInsets.fromLTRB(
    sectionHeaderHorizontalInset,
    8,
    sectionHeaderHorizontalInset,
    12,
  );
}

abstract final class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.green,
        onSecondary: Colors.white,
        tertiary: AppColors.blue,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 1,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.primary,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
    );
  }
}
