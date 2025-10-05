import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/containers/deem_card.dart';
import '../../../../core/widgets/containers/light_card.dart';
import '../../../../core/widgets/dividers/app_divider.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../screens/rewards_strings.dart';

class ChallengesPage extends ConsumerWidget {
  const ChallengesPage({super.key});

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
              color: isLightTheme(context) ? AppColors.softBlue : null,
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.paddingMedium,
                vertical: 20,
              ),
              child: Column(
                children: <Widget>[
                  SvgPicture.asset('assets/icons/trophy.svg', height: 40, width: 40),
                  const VerticalSpace(AppValues.paddingSmall),
                  Text(
                    weeklyChallenges,
                    style: s14W600(context).copyWith(
                        // color: AppColors.c212121,
                        ),
                  ),
                  const VerticalSpace(6),
                  Text(
                    completeChallengesToEarn,
                    style: s11W400(context).copyWith(
                        // color: AppColors.c757575,
                        ),
                  )
                ],
              ),
            ),
            const VerticalSpace(40),
            Text(
              challenges,
              style: s18W600(context),
            ),
            const VerticalSpace(AppValues.paddingLarge),
            ...[
              {
                "asset_path": "assets/icons/calender_with_bg.svg",
                "title": "7-Day Spending Streak",
                "subtitle": "Make a purchase every day for 7 days",
                "achievement": 4,
                "target": 7,
                "xpText": "100 XP + \$5 bonus",
              },
              {
                "asset_path": "assets/icons/cart_with_bg.svg",
                "title": "Merchant Explorer",
                "subtitle": "Purchase from 5 different merchants",
                "achievement": 3,
                "target": 5,
                "xpText": "200 XP + Gas rebate",
              },
              {
                "asset_path": "assets/icons/money_with_bg.svg",
                "title": "Early Repayor",
                "subtitle": "Repay before due date 3 times",
                "achievement": 1,
                "target": 3,
                "xpText": "150 XP + Credit boost",
              },
            ].map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppValues.paddingSmall),
                child: DeemCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: AppValues.paddingMedium,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        e['asset_path']?.toString() ?? '',
                        height: 40,
                        width: 40,
                      ),
                      const HorizontalSpace(AppValues.paddingSmall),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e['title']?.toString() ?? '',
                              style: s14W600(context),
                            ),
                            const VerticalSpace(AppValues.paddingSmall),
                            Text(
                              e['subtitle']?.toString() ?? '',
                              style: s12W400(context),
                            ),
                            const VerticalSpace(AppValues.paddingMedium),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  progress,
                                  style: s12W600(context),
                                ),
                                Text(
                                  '${e['achievement']}/${e['target']}',
                                  style: s12W600(context),
                                ),
                              ],
                            ),
                            const VerticalSpace(AppValues.paddingMedium),
                            AppProgressBar(
                              target: (e['target'] as int),
                              achievement: e['achievement'] as int,
                            ),
                            const VerticalSpace(AppValues.paddingSmall),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.rustBrown.withValues(alpha: .1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppValues.paddingSmall,
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    e['xpText']?.toString() ?? '',
                                    style: s12W600(context).copyWith(color: AppColors.rustBrown),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const VerticalSpace(AppValues.paddingLarge),
          ],
        ),
      ),
    );
  }
}
