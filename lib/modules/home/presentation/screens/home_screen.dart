import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/containers/light_card.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../data/models/latest_transaction.dart';
import '../resources/home_strings.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_available_to_spend.dart';
import '../widgets/home_credit_score_and_xp_points.dart';
import '../widgets/latest_transaction_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _latestTransactions = [
    LatestTransaction(
      title: 'Starbucks',
      address: '0xuywet7687y8jhw876hhbtxa3456',
      amount: 5.0,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'Book Worm',
      address: '0xuywet7687y8jhw876hhbtxa3456',
      amount: 2.3,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'J&G Cinema',
      address: '0xuywet7687y8jhw876hhbtxa3456',
      amount: 8.5,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'Starbucks',
      address: '0xuywet7687y8jhw876hhbtxa3456',
      amount: 5.0,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
    LatestTransaction(
      title: 'Starbucks',
      address: '0x................3456',
      amount: 5.0,
      currency: 'USDC',
      date: '11 Jul,25 : 03:55 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: isLightTheme(context)
          ? const Color(0xFFF5F5F5)
          : const Color(0xFF121212),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.paddingMedium),
              child: Column(
                children: [
                  VerticalSpace(padding.top),
                  const VerticalSpace(AppValues.paddingMedium),
                  HomeAppBar(
                    onGiftTap: () {},
                    onNotificationTap: () {},
                    onProfileTap: () {},
                    profileName: 'SH',
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  HomeAvailableToSpend(
                    onAddFound: () {
                      AppNav.goRouter.push(RtNm.addFoundScreen);
                    },
                    onRepayFound: () {
                      AppNav.goRouter.push(RtNm.replayFoundScreen);
                    },
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  const HomeCreditScoreAndXpPoints(),
                ],
              ),
            ),
            const VerticalSpace(AppValues.paddingMedium),
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
                        child: TitleText(text: latestTransactions),
                      ),
                      InkResponse(
                        onTap: () {},
                        child: Text(
                          seeAll,
                          style: s14W600(
                            context,
                            fontFamily: interFontFamily,
                          ).copyWith(
                            color: AppColors.primaryVariantLight,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryVariantLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(20),
                  ListView.builder(
                    itemCount: _latestTransactions.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return LatestTransactionTile(
                        latestTransaction: _latestTransactions[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
