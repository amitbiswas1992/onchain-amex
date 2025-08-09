import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/widgets/icon_outer_circle.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class HomeAppBar extends StatelessWidget {
  final String profileName;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onGiftTap;

  const HomeAppBar({
    super.key,
    required this.profileName,
    required this.onProfileTap,
    required this.onNotificationTap,
    required this.onGiftTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkResponse(
          onTap: onProfileTap,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(44),
            ),
            alignment: Alignment.center,
            child: Text(
              profileName,
              style: s14W600(context, fontFamily: interFontFamily)
                  .copyWith(color: AppColors.surfaceLight),
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
        IconOuterCircle(
          onTap: onGiftTap,
          icon: SvgPicture.asset('assets/icons/gift.svg'),
        ),
        const SizedBox(width: 16),
        IconOuterCircle(
          onTap: onNotificationTap,
          icon: SvgPicture.asset('assets/icons/bell.svg'),
        ),
      ],
    );
  }
}
