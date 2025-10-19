import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/extensions/big_int_extensions.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/containers/light_card.dart';
import '../../../../core/widgets/texts/large_number_text.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../wallet/data/models/borrower_profile.dart';
import '../resources/home_strings.dart';

class HomeCreditScoreAndXpPoints extends StatelessWidget {
  final BorrowerProfile? borrowerProfile;

  const HomeCreditScoreAndXpPoints({super.key, this.borrowerProfile});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              // AppNav.goRouter.push(RtNm.rewardsScreen);
            },
            child: LightCard(
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
                    creditScore,
                    style: s14W500(
                      context,
                      fontFamily: interFontFamily,
                    ),
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  LargeNumberText(text: num.parse(borrowerProfile?.creditScore ?? '0').toStringAsFixed(2), fontSize: 34,),
                  const VerticalSpace(32),
                ],
              ),
            ),
          ),
        ),
        const HorizontalSpace(AppValues.paddingMedium),
        Expanded(
          child: InkWell(
            onTap: () {
              // AppNav.goRouter.push(RtNm.rewardsScreen);
            },
            child: LightCard(
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
                    'Outstanding',
                    style: s14W500(
                      context,
                      fontFamily: interFontFamily,
                    ),
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  LargeNumberText(text: borrowerProfile?.outstandingDebt?.toBigInt().dividedByMillion().toStringAsFixed(2) ?? '0', fontSize: 34,),
                  const VerticalSpace(32),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
