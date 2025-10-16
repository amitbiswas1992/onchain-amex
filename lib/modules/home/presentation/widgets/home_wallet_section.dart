import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/string_extension.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/dialogs.dart';
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
      availableCreditProvider/*(profile?.wallet?.address ?? '')*/,
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
        asyncBorrowerProfile.when(
          data: (borrowerProfileResult) {
            switch (borrowerProfileResult) {
              case Ok<BorrowerProfile?>():
                return Column(
                  children: [
                    asyncCreditAmount.when(
                      data: (result) {
                        num availableCreditAmount = 0;

                        switch (result) {
                          case Ok<num?>():
                            availableCreditAmount = result.data ?? 0;
                          case Error<num?>():
                        }
                        log('Shaiful 1');
                        return _loadingWidget(
                          context: context,
                          profile: profile,
                          availableCreditAmount: availableCreditAmount,
                          borrowerProfile: borrowerProfileResult.data,
                        );
                      },
                      error: (error, stck) => WhenErrorWidget(error: error),
                      loading: () => _loadingWidget(
                        context: context,
                        availableCreditAmount: 0,
                        borrowerProfile: borrowerProfileResult.data,
                        profile: profile,
                      ),
                    ),
                  ],
                );
              case Error<BorrowerProfile?>():
                return Column(
                  children: [
                    HomeAvailableToSpend(
                      availableCreditAmount: 0,
                      profile: profile,
                      onRepayTap: () {},
                    ),
                    const VerticalSpace(AppValues.paddingMedium),
                    const HomeCreditScoreAndXpPoints(),
                  ],
                );
            }
          },
          error: (error, stck) => WhenErrorWidget(error: error),
          loading: () => _loadingWidget(
            context: context,
            profile: null,
            availableCreditAmount: null,
            borrowerProfile: null,
          ),
        ),
      ],
    );
  }

  _loadingWidget({
    required BuildContext context,
    required Profile? profile,
    required num? availableCreditAmount,
    required BorrowerProfile? borrowerProfile,
  }) {
    return Column(
      children: [
        HomeAvailableToSpend(
          availableCreditAmount: availableCreditAmount ?? 0,
          profile: profile,
      onRepayTap: () {
        if ((borrowerProfile?.outstandingDebt
            ?.toBigInt()
            .toDouble() ??
            0.0) <=
            0.0) {
          showWarningDialog(
              context: context,
              message: 'You have no outstanding to repay');
          return;
        }

        if (profile != null) {
          AppNav.goRouter.push(RtNm.replayFoundScreen,
              extra: borrowerProfile);
        }
      },
    ),
        const VerticalSpace(AppValues.paddingMedium),
        HomeCreditScoreAndXpPoints(borrowerProfile: borrowerProfile),
      ],
    );
  }
}
