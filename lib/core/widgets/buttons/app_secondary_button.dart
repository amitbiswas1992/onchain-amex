import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_values.dart';
import '../../utils/functions.dart';
import '../../utils/sizebox_util.dart';
import '../texts/text_styles.dart';

class AppSecondaryButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final double? radius;
  final TextStyle? titleStyle;
  final bool? isExpanded;
  final double? horizontalMargin;
  final double? verticalPadding;
  final bool rounded;
  final bool showBorder;
  final bool deepColor;

  const AppSecondaryButton({
    super.key,
    required this.title,
    this.onTap,
    // this.height,
    this.radius,
    this.titleStyle,
    this.isExpanded,
    this.horizontalMargin,
    this.verticalPadding,
    this.rounded = false,
    this.showBorder = true,
    this.deepColor = false,
  });

  @override
  Widget build(BuildContext context) {
    final lightTheme = isLightTheme(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        // height: height ?? 55,
        width: isExpanded == true ? double.infinity : null,
        padding: isExpanded == true
            ? EdgeInsets.symmetric(vertical: verticalPadding ?? AppValues.buttonVerticalPadding)
            : EdgeInsets.symmetric(
          horizontal: 24,
          vertical: ((verticalPadding ?? AppValues.buttonVerticalPadding) - 1),
        ),
        margin: horizontalMargin == null
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(
          horizontal: horizontalMargin ?? 0.0,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: lightTheme ? (deepColor ? Colors.black12 :AppColors.cF5F5F5) : AppColors.secondaryDark.withValues(alpha: .8),
          borderRadius: BorderRadius.circular(rounded ? 56 : (radius ?? 8)),
          border: showBorder ? Border.all(color: AppColors.borderColor, width: 1) : null,
        ),
        child: Text(
          title,
          // maxLines: 1,
          // overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: titleStyle ??
              s16W500(context).copyWith(color: lightTheme ? AppColors.onBackgroundLight : AppColors.onBackgroundDark),
        ),
      ),
    );
  }
}

