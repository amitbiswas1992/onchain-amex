import 'package:flutter/material.dart';

import '../resources/app_colors.dart';
import '../utils/functions.dart';

class AppProgressBar extends StatelessWidget {
  final int target;
  final int achievement;

  const AppProgressBar({
    super.key,
    required this.target,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: achievement,
          child: Container(
            height: 12,
            decoration: const BoxDecoration(
              color: AppColors.primaryVariantLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          flex: target - achievement,
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color:
                  isLightTheme(context) ? AppColors.surfaceLight : AppColors.secondaryVariantDark,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
