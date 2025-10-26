import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/big_int_extensions.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/containers/light_card.dart';
import '../../../../core/widgets/errors/when_error_widget.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../more/data/models/profile.dart';
import '../../../more/presentation/providers/more_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import '../../data/models/latest_transaction.dart';
import '../providers/home_providers.dart';
import '../resources/home_strings.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_wallet_section.dart';
import '../widgets/latest_transaction_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: isLightTheme(context)
          ? const Color(0xFFF5F5F5)
          : AppColors.backgroundDark,
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppValues.paddingMedium),
        child: Column(
          children: [
            VerticalSpace(padding.top),
            const VerticalSpace(AppValues.paddingMedium),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  Profile? profile;
                  final asyncProfile = ref.watch(profileProvider);

                  return asyncProfile.when(
                    data: (data) {
                      switch (data) {
                        case Ok<Profile?>():
                          profile = data.data;
                        case Error<Profile?>():
                      }

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
                          Expanded(
                            child: RefreshIndicator(
                              color: isLightTheme(context)
                                  ? AppColors.primaryLight
                                  : Colors.white,
                              onRefresh: () async {
                                ref.invalidate(availableCreditProvider);
                                ref.invalidate(borrowerProfileProvider);
                                ref.invalidate(transactionHistoryProvider);
                                ref.invalidate(profileProvider);
                                await Future.delayed(
                                  const Duration(milliseconds: 1000),
                                );
                              },
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    HomeWalletSection(profile: profile),
                                    const VerticalSpace(
                                      AppValues.paddingMedium,
                                    ),
                                    LightCard(
                                      radius: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppValues.paddingMedium,
                                      ),
                                      child: Column(
                                        children: [
                                          const VerticalSpace(20),
                                          Row(
                                            children: [
                                              const Expanded(
                                                child: TitleText(
                                                  text: latestTransactions,
                                                ),
                                              ),
                                              InkResponse(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                        bottomNavSelectedIndexProvider
                                                            .notifier,
                                                      )
                                                      .state = 3;
                                                  AppNav.goRouter.go(
                                                    RtNm.transactionsScreen,
                                                  );
                                                },
                                                child: Text(
                                                  seeAll,
                                                  style: s14W600(
                                                    context,
                                                    fontFamily: interFontFamily,
                                                  ).copyWith(
                                                    color: AppColors
                                                        .primaryVariantLight,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor: AppColors
                                                        .primaryVariantLight,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const VerticalSpace(20),
                                          Consumer(
                                            builder: (context, ref, _) {
                                              final transactionsState =
                                                  ref.watch(
                                                transactionHistoryProvider(
                                                  profile?.wallet?.address ??
                                                      '',
                                                ),
                                              );

                                              if (transactionsState.isLoading &&
                                                  transactionsState
                                                      .transactionHistory
                                                      .isEmpty) {
                                                return const SizedBox();
                                              }

                                              if (transactionsState
                                                  .transactionHistory.isEmpty) {
                                                return const Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: AppValues
                                                          .paddingMedium,
                                                    ),
                                                    child: Text(
                                                      'No transactions yet.',
                                                    ),
                                                  ),
                                                );
                                              }

                                              return ListView.builder(
                                                itemCount: transactionsState
                                                            .transactionHistory
                                                            .length >
                                                        10
                                                    ? 10
                                                    : transactionsState
                                                        .transactionHistory
                                                        .length,
                                                padding: const EdgeInsets.all(
                                                  AppValues.paddingMedium,
                                                ),
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  final transaction =
                                                      transactionsState
                                                              .transactionHistory[
                                                          index];
                                                  final merchantName =
                                                      transaction
                                                              .merchantName ??
                                                          '';
                                                  final merchantAddress =
                                                      transaction
                                                              .merchantAddress ??
                                                          '';
                                                  final amount = transaction
                                                          .amount
                                                          ?.toBigInt()
                                                          .dividedByMillion() ??
                                                      0.0;

                                                  final date = transaction
                                                              .timestamp ==
                                                          null
                                                      ? ''
                                                      : uiDateTimeFormat.format(
                                                          transaction.timestamp!
                                                              .toDateFromMillisecondsSinceEpoch()!,
                                                        );

                                                  return LatestTransactionTile(
                                                    latestTransaction:
                                                        LatestTransaction(
                                                      title: merchantName,
                                                      address: merchantAddress,
                                                      amount: amount,
                                                      currency: '',
                                                      date: date,
                                                      match: '',
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    error: (err, stack) => WhenErrorWidget(error: err),
                    loading: () => Column(
                      children: [
                        HomeAppBar(
                          onGiftTap: () {},
                          onNotificationTap: () {},
                          onProfileTap: () {},
                          profileName: '',
                        ),
                        const VerticalSpace(AppValues.paddingMedium),
                        const HomeWalletSection(profile: null),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
