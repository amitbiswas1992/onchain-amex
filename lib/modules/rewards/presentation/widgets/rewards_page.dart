import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/containers/light_card.dart';
import '../../../../core/widgets/texts/large_number_text.dart';
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
          children: [
            LightCard(
              color: AppColors.softGreen,
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
                  Text('45.22', style: s32W600(context),),
                  const VerticalSpace(AppValues.paddingMedium),
                  const AppPrimaryButton(
                    title: claimRewards,
                    verticalPadding: AppValues.paddingSmall + 4,
                  ),
                ],
              ),
            ),
            const VerticalSpace(AppValues.paddingLarge),
          ],
        ),
      ),
    );
  }
}
