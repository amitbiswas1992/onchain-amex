import 'package:flutter/material.dart';

import '../../core/resources/app_colors.dart';
import '../../core/resources/app_values.dart';
import '../widgets/shapes/custom_value_indicator_shape.dart';
import '../widgets/shapes/hollow_circle_thumb_shape.dart';
import '../widgets/texts/text_styles.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: segoeProFontFamily,
    primaryColor: AppColors.primaryLight,
    primaryColorDark: AppColors.primaryVariantLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        // color: AppColors.onBackgroundLight,
        letterSpacing: 0,
        height: 1,
      ),
      bodyMedium: TextStyle(
        // color: AppColors.onBackgroundLight,
        letterSpacing: 0,
        height: 1,
      ),
      bodySmall: TextStyle(
        // color: Colors.grey,
        letterSpacing: 0,
        height: 1,
        fontWeight: FontWeight.w400,
        fontSize: 11,
      ),
      titleLarge: TextStyle(
        // color: AppColors.onBackgroundLight,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        // color: AppColors.onBackgroundLight,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1,
        letterSpacing: 0,
      ),
      titleSmall: TextStyle(
        // color: AppColors.onBackgroundLight,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1,
        letterSpacing: 0,
      ),
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
      titleTextStyle: TextStyle(color: AppColors.onPrimaryLight, fontSize: 20),
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
      onSurface: AppColors.onBackgroundLight,
      onError: AppColors.onErrorLight,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.c212121,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryLight.withValues(alpha: .8),
      inactiveTrackColor: Colors.grey.shade300,
      trackHeight: 4,
      thumbShape: const HollowCircleThumbShape(
        hollowColor: AppColors.surfaceLight,
      ),
      overlayShape: SliderComponentShape.noOverlay,
      valueIndicatorShape: const CustomValueIndicatorShape(
        backgroundColor: AppColors.surfaceLight,
        borderColor: Colors.blueGrey,
        borderWidth: 1,
        padding: EdgeInsets.symmetric(horizontal: AppValues.paddingSmall, vertical: 6),
      ),// White background
      valueIndicatorTextStyle: const TextStyle(
        color: AppColors.onSurfaceLight, // Black text
      ),
      showValueIndicator: ShowValueIndicator.always,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: segoeProFontFamily,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    primaryColorDark: AppColors.primaryVariantDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    iconTheme: const IconThemeData(
      color: AppColors.secondaryVariantDark,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        // color: AppColors.onBackgroundLight,
        letterSpacing: 0,
        height: 1,
      ),
      bodyMedium: TextStyle(
        // color: AppColors.onBackgroundLight,
        letterSpacing: 0,
        height: 1,
      ),
      bodySmall: TextStyle(
        // color: Colors.grey,
        letterSpacing: 0,
        height: 1,
        fontWeight: FontWeight.w400,
        fontSize: 11,
      ),
      titleLarge: TextStyle(
        // color: AppColors.onBackgroundLight,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        // color: AppColors.onBackgroundLight,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1,
        letterSpacing: 0,
      ),
      titleSmall: TextStyle(
        // color: AppColors.onBackgroundLight,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1,
        letterSpacing: 0,
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryDark,
      titleTextStyle: TextStyle(color: AppColors.onPrimaryDark, fontSize: 20),
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
      onSurface: AppColors.onBackgroundDark,
      onError: AppColors.onErrorDark,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryLight.withValues(alpha: .8),
      inactiveTrackColor: Colors.grey.shade300,
      trackHeight: 4,
      thumbShape: const HollowCircleThumbShape(
        hollowColor: AppColors.surfaceDark
      ),
      overlayShape: SliderComponentShape.noOverlay,
      showValueIndicator: ShowValueIndicator.always,
      valueIndicatorShape: const CustomValueIndicatorShape(
        backgroundColor: AppColors.surfaceLight,
        borderColor: Colors.blueGrey,
        borderWidth: 1,
        padding: EdgeInsets.symmetric(horizontal: AppValues.paddingSmall, vertical: 6),
      ),
      valueIndicatorTextStyle: const TextStyle(
        color: AppColors.onSurfaceDark, // Black text
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, // applies to 'Cancel' and 'OK' buttons
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
