import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFFA63A18);
  static const secondary = Color(0xFFC85A2E);
  static const background = Color(0xFFFBF7F5);
  static const card = Color(0xFFFFFFFF);
  static const softPink = Color(0xFFFFD5CA);
  static const textDark = Color(0xFF151515);
  static const textBrown = Color(0xFF5A4038);
  static const border = Color(0xFFE8D8D2);
  static const muted = Color(0xFFF3ECE9);
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(useMaterial3: true, scaffoldBackgroundColor: AppColors.background, colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary, secondary: AppColors.secondary, surface: AppColors.card));
    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(fontSize: 54, fontWeight: FontWeight.w800, color: AppColors.textDark),
        headlineLarge: GoogleFonts.playfairDisplay(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.textDark),
        headlineMedium: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark),
        titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark),
        bodyLarge: GoogleFonts.poppins(fontSize: 16, color: AppColors.textBrown),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, color: AppColors.textBrown),
      ),
      appBarTheme: AppBarTheme(backgroundColor: AppColors.background, elevation: 0, scrolledUnderElevation: 0, centerTitle: true, titleTextStyle: GoogleFonts.poppins(fontSize: 24, color: AppColors.primary, fontWeight: FontWeight.w800), iconTheme: const IconThemeData(color: AppColors.primary)),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700))),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(foregroundColor: AppColors.textDark, side: const BorderSide(color: AppColors.border), minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: AppColors.card, hintStyle: const TextStyle(color: Color(0xFF9C827A)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: AppColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: AppColors.border)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: AppColors.primary))),
      cardTheme: CardThemeData(color: AppColors.card, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border))),
    );
  }
}
