import 'package:flutter/material.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';

class AmexTextAppBar extends StatelessWidget {
  const AmexTextAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Column(
      children: [
        VerticalSpace(
          padding.top + AppValues.paddingLarge + AppValues.paddingMedium,
        ),
        Center(
          child: Image.asset(
            isLightTheme(context)
                ? 'assets/app_icons/text-logo-black.png'
                : 'assets/app_icons/text-logo-white.png',
            width: 150,
          ),
          // child: Text(
          //   amex,
          //   textAlign: TextAlign.center,
          //   style: s32W600(context).copyWith(
          //     color: isLightTheme(context)
          //         ? AppColors.primaryVariantLight
          //         : AppColors.primaryLight,
          //   ),
          // ),
        ),
      ],
    );
  }
}
