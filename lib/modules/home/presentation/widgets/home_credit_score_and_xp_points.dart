import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/containers/app_card.dart';
import '../../../../core/widgets/containers/app_card.dart';
import '../../../../core/widgets/texts/large_number_text.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../resources/home_strings.dart';

class HomeCreditScoreAndXpPoints extends StatelessWidget {
  const HomeCreditScoreAndXpPoints({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.paddingMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpace(12),
                SvgPicture.asset('assets/icons/usd_with_bg.svg'),
                const VerticalSpace(AppValues.paddingSmall),
                Text(
                  creditScore,
                  style: s14W500(
                    context,
                    fontFamily: interFontFamily,
                  ),
                ),
                const VerticalSpace(AppValues.paddingMedium),
                const LargeNumberText(text: '750', fontSize: 34,),
                const VerticalSpace(32),
              ],
            ),
          ),
        ),
        const HorizontalSpace(AppValues.paddingMedium),
        Expanded(
          child: AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.paddingMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpace(12),
                SvgPicture.asset('assets/icons/star_with_bg.svg'),
                const VerticalSpace(AppValues.paddingSmall),
                Text(
                  xpPoints,
                  style: s14W500(
                    context,
                    fontFamily: interFontFamily,
                  ),
                ),
                const VerticalSpace(AppValues.paddingMedium),
                const LargeNumberText(text: '750', fontSize: 34,),
                const VerticalSpace(32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
