import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class BottomNavItem extends StatelessWidget {
  final String label;
  final String svgPath;
  final bool largeIcon;
  final bool isSelected;
  final VoidCallback onItemTap;

  const BottomNavItem({
    super.key,
    required this.label,
    required this.svgPath,
    this.largeIcon = false,
    required this.isSelected,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLightThem = isLightTheme(context);

    return InkResponse(
      onTap: onItemTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            svgPath,
            height: largeIcon ? 44 : 24,
            width: largeIcon ? 44 : 24,
            colorFilter: largeIcon
                ? null
                : ColorFilter.mode(
                    isLightThem
                        ? (isSelected ? Colors.black : AppColors.c757575)
                        : (isSelected ? Colors.white : AppColors.cAFBACA),
                    BlendMode.srcIn),
          ),
          const VerticalSpace(AppValues.paddingSmall),
          Text(
            label,
            style: s11W700(context).copyWith(
              color: isLightThem
                  ? (isSelected ? Colors.black : AppColors.c757575)
                  : (isSelected ? Colors.white : AppColors.cAFBACA),
            ),
          ),
        ],
      ),
    );
  }
}
