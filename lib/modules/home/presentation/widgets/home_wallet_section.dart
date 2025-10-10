import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/errors/when_error_widget.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../more/data/models/profile.dart';
import '../../../wallet/data/models/borrower_profile.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import 'home_app_bar.dart';
import 'home_available_to_spend.dart';
import 'home_credit_score_and_xp_points.dart';

class HomeWalletSection extends ConsumerWidget {
  final Profile? profile;

  const HomeWalletSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context, ref) {
    final asyncCreditAmount = ref.watch(
      availableCreditProvider(profile?.wallet?.address ?? ''),
    );

    final asyncBorrowerProfile = ref.watch(
      borrowerProfileProvider(profile?.wallet?.address ?? ''),
    );

    return Column(
      children: [
        HomeAppBar(
          onGiftTap: () {
            AppNav.goRouter.push(RtNm.rewardsScreen);
          },
          onNotificationTap: () {},
          onProfileTap: () {},
          profileName: profile?.getShortName() ?? '',
        ),
        const VerticalSpace(AppValues.paddingMedium),
        asyncCreditAmount.when(
          data: (result) {
            num availableCreditAmount = 0;

            switch (result) {
              case Ok<num?>():
                availableCreditAmount = result.data ?? 0;
              case Error<num?>():
            }

            return HomeAvailableToSpend(
              availableCreditAmount: availableCreditAmount,
              profile: profile,
            );
          },
          error: (error, stck) => WhenErrorWidget(error: error),
          loading: () => HomeAvailableToSpend(
            availableCreditAmount: 0,
            profile: profile,
          ),
        ),
        const VerticalSpace(AppValues.paddingMedium),
        asyncBorrowerProfile.when(
          data: (result) {
            switch (result) {
              case Ok<BorrowerProfile?>():
                return HomeCreditScoreAndXpPoints(borrowerProfile: result.data);
              case Error<BorrowerProfile?>():
                return const HomeCreditScoreAndXpPoints();
            }
          },
          error: (error, stck) => WhenErrorWidget(error: error),
          loading: () => const HomeCreditScoreAndXpPoints(),
        ),
      ],
    );
  }
}
