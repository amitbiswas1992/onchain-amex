import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/containers/light_card.dart';
import '../../../../core/widgets/dividers/app_divider.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../screens/rewards_strings.dart';

class RewardsPage extends ConsumerWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LightCard(
              color: isLightTheme(context) ? AppColors.softGreen : null,
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.paddingMedium,
                vertical: 20,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    totalRewardsEarned,
                    style: s14W400(context),
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  // const LargeNumberText(text: '45.22'),
                  Text(
                    '45.22',
                    style: s32W600(context),
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  const AppPrimaryButton(
                    title: claimRewards,
                    verticalPadding: AppValues.paddingSmall + 4,
                  ),
                ],
              ),
            ),
            const VerticalSpace(40),
            Text(
              rewardsPerks,
              style: s18W600(context),
            ),
            const VerticalSpace(AppValues.paddingLarge),
            ...[
              {
                "assetPath": 'assets/icons/percentage_with_bg.svg',
                "title": "2% Cashback",
                "subTitle": "On all merchant purchases",
                "amount": "\$12.33",
                "status": "This month",
              },
              {
                "assetPath": 'assets/icons/money_with_bg.svg',
                "title": "Gas Rebates",
                "subTitle": "Transaction fee reimbursements",
                "amount": "\$12.33",
                "status": "This month",
              },
              {
                "assetPath": 'assets/icons/gift_with_bg.svg',
                "title": "Referral Bonus",
                "subTitle": "For inviting new users",
                "amount": "\$10.00",
                "status": "Pending",
              },
            ].map((e) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: AppValues.paddingMedium,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          e['assetPath'] ?? '',
                          height: 40,
                          width: 40,
                        ),
                        const HorizontalSpace(AppValues.paddingSmall),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e['title'] ?? '',
                                style: s14W600(context),
                              ),
                              const VerticalSpace(AppValues.paddingSmall),
                              Text(
                                e['subTitle'] ?? '',
                                style: s12W400(context),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              e['amount'] ?? '',
                              style: s14W600(context),
                            ),
                            const VerticalSpace(AppValues.paddingSmall),
                            Text(
                              e['status'] ?? '',
                              style: s12W400(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const AppDivider(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
