import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_values.dart';
import '../../utils/sizebox_util.dart';
import '../texts/text_styles.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Color? color;
  final Function()? onTap;
  // final double? height;
  final double? radius;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final bool? isExpanded;
  final double? horizontalMargin;
  final double? verticalPadding;
  final bool? showBorder;

  const AppButton({
    super.key,
    required this.title,
    this.color,
    this.onTap,
    // this.height,
    this.radius,
    this.titleStyle,
    this.titleColor,
    this.isExpanded,
    this.horizontalMargin,
    this.verticalPadding,
    this.showBorder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: height ?? 55,
        width: isExpanded == true ? double.infinity : null,
        padding: isExpanded == true
            ? EdgeInsets.symmetric(vertical: verticalPadding ?? AppValues.buttonVerticalPadding)
            : EdgeInsets.symmetric(
                horizontal: 24,
                vertical: verticalPadding ?? AppValues.buttonVerticalPadding,
              ),
        margin: horizontalMargin == null
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(
                horizontal: horizontalMargin ?? 0.0,
              ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? AppColors.primaryLight,
          borderRadius: BorderRadius.circular(radius ?? 8),
          border: showBorder == true ? Border.all(color: AppColors.borderColor) : null,
        ),
        child: Text(
          title,
          // maxLines: 1,
          // overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: titleStyle ??
              s16W500(context).copyWith(color: titleColor ?? AppColors.backgroundLight),
        ),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final String title;
  final Color? color;
  final Function()? onTap;
  final double? height;
  final double? radius;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final bool? isExpanded;
  final double? horizontalMargin;
  final Widget icon;

  const AppIconButton({
    super.key,
    required this.title,
    required this.icon,
    this.color,
    this.onTap,
    this.height,
    this.radius,
    this.titleStyle,
    this.titleColor,
    this.isExpanded,
    this.horizontalMargin,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 55,
        width: isExpanded == true ? double.infinity : null,
        padding: isExpanded == true ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 24),
        margin: horizontalMargin == null
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(
                horizontal: horizontalMargin ?? 0.0,
              ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(radius ?? 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const HorizontalSpace(AppValues.paddingSmall),
            Text(
              title,
              style: titleStyle ??
                  TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
