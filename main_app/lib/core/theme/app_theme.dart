import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const ink = Color(0xFF12151A);
  static const mist = Color(0xFFF3F1EC);
  static const panel = Color(0xFFF7F5F1);
  static const accent = Color(0xFFE8A838);
  static const accentDeep = Color(0xFFC67D12);
  static const forest = Color(0xFF1F6B4A);
  static const glass = Color(0xCC161A1F);
  static const line = Color(0x22FFFFFF);
}

abstract final class AppTheme {
  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.forest,
      brightness: Brightness.light,
      primary: AppColors.forest,
      secondary: AppColors.accentDeep,
      surface: AppColors.mist,
    );

    final textTheme = GoogleFonts.soraTextTheme().apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: AppColors.mist,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.mist,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: AppColors.ink,
          letterSpacing: -0.4,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.forest.withValues(alpha: 0.12),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.ink,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.sora(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: GoogleFonts.sora(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
