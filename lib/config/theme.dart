import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Poppins',
    textTheme: TextTheme(
      displayLarge: GoogleFonts.kodchasan(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      displayMedium: GoogleFonts.kodchasan(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      bodyLarge: GoogleFonts.kodchasan(
        fontSize: 15,
        color: AppColors.primary,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: AppColors.primary,
      secondary: AppColors.banner,
    ),
  );
}
