import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_values.dart';
import '../../utils/functions.dart';
import '../texts/text_styles.dart';
import 'deem_card.dart';

class AppChip extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const AppChip({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DeemCard(
        disableInfiniteWidth: true,
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingSmall,
          vertical: 4,
        ),
        child: Text(
          text,
          style: s14W500(context).copyWith(
            color: isLightTheme(context) ? AppColors.c455468 : AppColors.secondaryVariantDark,
          ),
        ),
      ),
    );
  }
}
