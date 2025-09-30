// app_theme.dart
import 'package:flutter/material.dart';
import 'package:todo_app/core/style/app_color.dart';
import 'package:todo_app/gen/fonts.gen.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: FontFamily.comfortaa,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      foregroundColor: AppColors.textPrimary,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: FontFamily.comfortaa,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontFamily: FontFamily.comfortaa,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(fontFamily: FontFamily.comfortaa),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardBackground,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(14),
      ),
      hintStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.comfortaa,
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.textPrimary,
        fontFamily: FontFamily.comfortaa,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
        fontFamily: FontFamily.comfortaa,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontFamily: FontFamily.comfortaa,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: FontFamily.comfortaa,
        ),
      ),
    ),
    cardColor: AppColors.background,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: FontFamily.comfortaa,

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      foregroundColor: AppColors.darkTextPrimary,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: FontFamily.comfortaa,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.darkTextPrimary,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.darkTextSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontFamily: FontFamily.comfortaa,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(fontFamily: FontFamily.comfortaa),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(14),
      ),
      hintStyle: const TextStyle(
        color: AppColors.background,
        fontFamily: FontFamily.comfortaa,
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.background,
        fontFamily: FontFamily.comfortaa,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.background,
        fontFamily: FontFamily.comfortaa,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.background,
        fontFamily: FontFamily.comfortaa,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: FontFamily.comfortaa,
        ),
      ),
    ),
    cardColor: AppColors.darkBackground,
  );
}
