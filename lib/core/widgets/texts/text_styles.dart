import 'package:flutter/material.dart';
import '../../../infrastructure/navigation/app_nav.dart';
import '../../resources/app_colors.dart';
import '../../utils/functions.dart';

const interFontFamily = 'Inter';
const segoeProFontFamily = 'Segoe Pro';

// Theme aware text styles
TextStyle s28W600(BuildContext context, {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? segoeProFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: isLightTheme(context) ? AppColors.onSurfaceLight : AppColors.onSurfaceDark,
    letterSpacing: 0,
    height: 1,
  );
}

TextStyle s14W400(BuildContext context, {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? segoeProFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: isLightTheme(context) ? AppColors.c424242 : AppColors.onSurfaceDark,
    letterSpacing: 0,
    height: 1,
  );
}

TextStyle s16W500(BuildContext context, {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? segoeProFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: isLightTheme(context) ? AppColors.c212121 : AppColors.onSurfaceDark,
    letterSpacing: 0,
    height: 1,
  );
}

TextStyle s16W400(BuildContext context, {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? segoeProFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: isLightTheme(context) ? AppColors.c212121 : AppColors.onSurfaceDark,
    letterSpacing: 0,
    height: 1,
  );
}

TextStyle s14W500(BuildContext context, {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? segoeProFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.c455468,
    // same color for both themes
    letterSpacing: 0,
    height: 1,
  );
}

TextStyle s14W600(BuildContext context, {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? segoeProFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.c616161,
    // same color for both themes
    letterSpacing: 0,
    height: 1,
  );
}

TextStyle s12W400(BuildContext context, {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? segoeProFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.c757575,
    // same color for both themes
    letterSpacing: 0,
    height: 1,
  );
}

TextStyle s32W600(BuildContext context, {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? segoeProFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: isLightTheme(context) ? AppColors.onSurfaceLight : AppColors.onSurfaceDark,
    letterSpacing: 0,
    height: 1,
  );
}

TextStyle s24W500(BuildContext context, {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? segoeProFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: isLightTheme(context) ? AppColors.onBackgroundLight : AppColors.onBackgroundDark,
    letterSpacing: 0,
    height: 1,
  );
}

// s17w400
TextStyle s17W400(BuildContext context, {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? segoeProFontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: isLightTheme(context) ? AppColors.onBackgroundLight : AppColors.onBackgroundDark,
  );
}

TextStyle s11W700(BuildContext context, {String? fontFamily}) {
  return TextStyle(
    fontFamily: fontFamily ?? segoeProFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: isLightTheme(context) ? AppColors.onBackgroundLight : AppColors.onBackgroundDark,
  );
}
