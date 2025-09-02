import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:port_calculator/config/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        foregroundColor: AppColors.textBlue,
        padding: EdgeInsets.zero,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        bodySmall: TextStyle(
          color: AppColors.textGray,
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textBlue,
          fontSize: 32.0,
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: TextStyle(
          color: Color(0xff424242),
          fontSize: 48.0,
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textDarkerGray,
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        foregroundColor: AppColors.textBlue,
        padding: EdgeInsets.zero,
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        bodySmall: TextStyle(
          color: AppColors.textGray,
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textBlue,
          fontSize: 32.0,
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 48.0,
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textDarkerGray,
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
