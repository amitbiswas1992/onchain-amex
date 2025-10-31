import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/resources/app_values.dart';
import '../../../../../core/utils/decimal_converter.dart';
import '../../../../../core/utils/functions.dart';
import '../../../../../core/utils/sizebox_util.dart';
import '../../../../../core/widgets/texts/text_styles.dart';
import '../../../borrower/home/data/models/latest_transaction.dart';
import '../../../borrower/more/presentation/providers/more_providers.dart';
import '../../../infrastructure/navigation/app_nav.dart';
import '../../../infrastructure/navigation/rt_nm.dart';
import '../../../infrastructure/network/result.dart';
import '../../../lender/home/presentation/widgets/home_app_bar.dart';
import '../../../lender/lender_transactions/presentation/providers/transaction_providers.dart';
import '../model/merchant_profile.dart';

class MerchantHomeScreen extends ConsumerStatefulWidget {
  const MerchantHomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<MerchantHomeScreen>
    with WidgetsBindingObserver {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // Refresh data when app comes back to foreground or screen is visible
  //   if (state == AppLifecycleState.resumed) {
  //     _refreshBlockchainData();
  //   }
  // }

  void _refreshBlockchainData() {
    // Invalidate all blockchain-related providers to fetch fresh data
    ref.invalidate(merchantProfileProvider);
    ref.invalidate(transactionHistoryProvider);
    ref.invalidate(profileProvider);
  }

  Future<void> _onRefresh() async {
    _refreshBlockchainData();
    // Wait a bit for the providers to fetch new data
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: isLightTheme(context)
          ? const Color(0xFFF5F5F5)
          : const Color(0xFF121212),
      appBar: profileAsync.when(
        data: (data) => HomeAppBar(
          onGiftTap: () {
            AppNav.goRouter.push(RtNm.rewardsScreen);
          },
          onNotificationTap: () {},
          onProfileTap: () {},
          profileName: data.data?.firstName?.substring(0, 2).toUpperCase() ??
              'Merchant'.substring(0, 2).toUpperCase(),
        ),
        loading: () => HomeAppBar(
          onGiftTap: () {
            AppNav.goRouter.push(RtNm.rewardsScreen);
          },
          onNotificationTap: () {},
          onProfileTap: () {},
          profileName: '',
        ),
        error: (_, __) => HomeAppBar(
          onGiftTap: () {
            AppNav.goRouter.push(RtNm.rewardsScreen);
          },
          onNotificationTap: () {},
          onProfileTap: () {},
          profileName: '',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.paddingMedium,
                ),
                child: Column(
                  children: [
                    const VerticalSpace(AppValues.paddingMedium),
                    const BalanceCard(),
                    const VerticalSpace(AppValues.paddingMedium),
                    InviteFriendsCard(
                      referralCode:
                          profileAsync.valueOrNull?.data?.referralCode ?? '',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BalanceCard extends ConsumerWidget {
  const BalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(merchantProfileProvider);
    ref.watch(profileProvider);
    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppValues.borderRadiusMedium),
      ),
      child: Column(
        children: [
          Text(
            'My balance',
            style: s14W400(
              context,
              fontFamily: interFontFamily,
            ).copyWith(color: Colors.white.withValues(alpha: 0.9)),
          ),
          const VerticalSpace(8),
          profile.when(
            data: (data) {
              String? balance;
              switch (data) {
                case Ok<MerchantProfile?>():
                  balance = data.data?.balance;
                case Error<MerchantProfile?>():
              }
              return Text(
                '\$${DecimalConverter.toUiAmount(
                  BigInt.from(double.tryParse(balance ?? '0') ?? 0),
                ).toStringAsFixed(2)}',
                style: s32W600(
                  context,
                  fontFamily: interFontFamily,
                ).copyWith(color: Colors.white, fontSize: 36),
              );
            },
            loading: () => Text(
              '---',
              style: s32W600(
                context,
                fontFamily: interFontFamily,
              ).copyWith(color: Colors.white, fontSize: 36),
            ),
            error: (_, __) => Text(
              '0.00',
              style: s32W600(
                context,
                fontFamily: interFontFamily,
              ).copyWith(color: Colors.white, fontSize: 36),
            ),
          ),
          const VerticalSpace(28),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryVariantLight,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: InkWell(
                    onTap: () {
                      AppNav.goRouter.pushNamed(RtNm.merchantWithdrawScreen);
                    },
                    child: Text(
                      'Withdraw',
                      textAlign: TextAlign.center,
                      style: s14W600(
                        context,
                        fontFamily: interFontFamily,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LockupBonusCard extends StatelessWidget {
  const LockupBonusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLightTheme(context) ? Colors.white : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppValues.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.attach_money_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const HorizontalSpace(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Current lockup bonus ',
                      style: s14W500(context, fontFamily: interFontFamily),
                    ),
                    Text(
                      '20.50%',
                      style: s16W500(context, fontFamily: interFontFamily),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // AppNav.goRouter.push(RtNm.increaseScreen);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Increase',
                style: s14W500(
                  context,
                  fontFamily: interFontFamily,
                ).copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InviteFriendsCard extends StatelessWidget {
  const InviteFriendsCard({super.key, required this.referralCode});
  final String referralCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLightTheme(context) ? Colors.white : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppValues.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.people_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/share.svg',
                    width: 24,
                    height: 24,
                  ),
                  const HorizontalSpace(4),
                  Text(
                    'Share',
                    style: s14W600(
                      context,
                      fontFamily: interFontFamily,
                    ).copyWith(color: AppColors.primaryLight),
                  ),
                ],
              ),
            ],
          ),
          const VerticalSpace(16),
          Text(
            'Invite your friend and get awesome rewards!',
            style: s20W500(context, fontFamily: interFontFamily),
          ),
          const VerticalSpace(12),
          Text(
            'Alternatively you can use your invitation code',
            style: s14W400(
              context,
              fontFamily: interFontFamily,
            ).copyWith(color: AppColors.c757575),
          ),
          const VerticalSpace(12),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: referralCode));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.jungleGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    referralCode,
                    style: s14W600(
                      context,
                      fontFamily: interFontFamily,
                    ).copyWith(color: AppColors.jungleGreen),
                  ),
                  const HorizontalSpace(8),
                  const Icon(
                    Icons.copy,
                    color: AppColors.jungleGreen,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentActivityTile extends StatelessWidget {
  final LatestTransaction activity;

  const RecentActivityTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final amount = activity.amount ?? 0.0;
    final isPositive = amount > 0;
    final amountText = isPositive
        ? '+${amount.toStringAsFixed(amount < 1 ? 4 : 2)}'
        : amount.toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title ?? '', style: s16W600(context)),
                const VerticalSpace(4),
                if (activity.address?.isNotEmpty == true) ...[
                  const VerticalSpace(4),
                  Text(
                    activity.address ?? '',
                    style: s12W400(context).copyWith(color: AppColors.c757575),
                  ),
                  const VerticalSpace(8),
                ],
                Text(
                  activity.date ?? '',
                  style: s12W600(context).copyWith(color: AppColors.c757575),
                ),
              ],
            ),
          ),
          Text(
            amountText,
            style: s16W600(
              context,
            ).copyWith(color: isPositive ? Colors.black : AppColors.errorLight),
          ),
        ],
      ),
    );
  }
}
