import 'package:flutter/material.dart';

import '../resources/app_colors.dart';
import '../utils/sizebox_util.dart';
import 'texts/text_styles.dart';

class AppPickerButton extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final Function() onTap;
  final String? value;
  final String? hint;
  final Widget? icon;
  final EdgeInsets? padding;
  final double? height;
  final BoxDecoration? decoration;

  const AppPickerButton({
    super.key,
    required this.onTap,
    this.borderRadius,
    this.backgroundColor,
    this.value,
    this.hint,
    this.icon, this.padding, this.height, this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: height ?? AppValues.defaultInputBoxHeight,
        decoration: decoration ?? BoxDecoration(
          // color: backgroundColor ?? Colors.white,
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          border: Border.all(color: AppColors.borderColor),
        ),
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? hint ?? 'Pick',
                style: s14W400(context),
              ),
            ),
            const HorizontalSpace(8),
            icon ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
