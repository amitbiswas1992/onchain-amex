import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_values.dart';
import '../../utils/sizebox_util.dart';
import '../texts/text_styles.dart';

class GreenRoundedIconButton extends StatelessWidget {
  final double? size;
  final String assetPath;
  final VoidCallback onTap;
  final String? title;

  const GreenRoundedIconButton({
    super.key,
    this.size,
    required this.assetPath,
    required this.onTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: size ?? 40,
            width: size ?? 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(100),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              assetPath,
              height: 24,
              width: 24,
            ),
          ),
          if (title != null) const VerticalSpace(AppValues.paddingSmall),
          if (title != null)
            Text(
              title ?? '',
              style: s12W600(context),
            ),
        ],
      ),
    );
  }
}
