import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../utils/functions.dart';


class DeemCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final double radius;
  final bool disableInfiniteWidth;

  const DeemCard({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.width,
    this.radius = 16,
    this.disableInfiniteWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .01,
      margin: EdgeInsets.zero,
      color: isLightTheme(context) ? AppColors.cF5F5F5 : AppColors.primaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: SizedBox(
          height: height,
          width: disableInfiniteWidth ? null : width ?? double.infinity,
          child: child,
        ),
      ),
    );
  }
}
