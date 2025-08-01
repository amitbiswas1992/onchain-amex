import 'package:flutter/material.dart';

import '../../core/resources/app_colors.dart';
import '../../core/resources/app_values.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Segoe Pro',
    primaryColor: AppColors.primaryLight,
    primaryColorDark: AppColors.primaryVariantLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.onBackgroundLight),
      bodyMedium: TextStyle(color: AppColors.onBackgroundLight),
      bodySmall: TextStyle(color: AppColors.onBackgroundLight),
      // displayLarge: TextStyle(letterSpacing: 0, height: 1),
      // displayMedium: TextStyle(letterSpacing: 0, height: 1),
      // displaySmall: TextStyle(letterSpacing: 0, height: 1),
      // headlineLarge: TextStyle(letterSpacing: 0, height: 1),
      // headlineMedium: TextStyle(letterSpacing: 0, height: 1),
      // headlineSmall: TextStyle(letterSpacing: 0, height: 1),
      // titleLarge: TextStyle(letterSpacing: 0, height: 1),
      // titleMedium: TextStyle(letterSpacing: 0, height: 1),
      // titleSmall: TextStyle(letterSpacing: 0, height: 1),
      // labelLarge: TextStyle(letterSpacing: 0, height: 1),
      // labelMedium: TextStyle(letterSpacing: 0, height: 1),
      // labelSmall: TextStyle(letterSpacing: 0, height: 1),
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryLight,
      titleTextStyle:  TextStyle(color: AppColors.onPrimaryLight, fontSize: 20),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadiusSmall),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadiusSmall),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadiusSmall),
      ),
      hintStyle: const TextStyle(
        color: AppColors.onSurfaceLight,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      surface: AppColors.surfaceLight,
      error: AppColors.errorLight,
      onPrimary: AppColors.onPrimaryLight,
      onSecondary: AppColors.onSecondaryLight,
      onSurface: AppColors.onSurfaceLight,
      onError: AppColors.onErrorLight,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.primaryLight,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    primaryColorDark: AppColors.primaryVariantDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.onBackgroundDark),
      bodyMedium: TextStyle(color: AppColors.onBackgroundDark),
      bodySmall: TextStyle(color: AppColors.onBackgroundDark),
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryDark,
      titleTextStyle:  TextStyle(color: AppColors.onPrimaryDark, fontSize: 20),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadiusSmall),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadiusSmall),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppValues.borderRadiusSmall),
      ),
      hintStyle: const TextStyle(
        color: AppColors.onSurfaceDark,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      surface: AppColors.surfaceDark,
      error: AppColors.errorDark,
      onPrimary: AppColors.onPrimaryDark,
      onSecondary: AppColors.onSecondaryDark,
      onSurface: AppColors.onSurfaceDark,
      onError: AppColors.onErrorDark,
    ),
  );
}
