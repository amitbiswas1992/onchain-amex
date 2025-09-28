import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/theme_toogle_button.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/errors/when_error_widget.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/transaction_hash_text.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../connect_wallet/presentation/providers/wallet_providers.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../connect_wallet/presentation/controllers/wallet_controller.dart';
import '../../data/models/profile.dart';
import '../providers/more_providers.dart';
import '../widgets/menu_section.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {

  late final WalletController _walletController;

  @override
  void initState() {
    _walletController = WalletController(
      context: context,
      ref: ref,
      walletRepo: ref.read(walletRepoProvider),
    );
    super.initState();
  }

  @override
  void dispose() {
    _walletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              VerticalSpace(padding.top + AppValues.paddingSmall),
              Align(
                alignment: Alignment.centerRight,
                child: ThemeToggleButton(
                  isDarkMode: isLightTheme(context) == false,
                  onToggle: () {
                    ref.read(themeModeProvider.notifier).state = isLightTheme(context)
                        ? ThemeMode.dark
                        : ThemeMode.light;
                    ref.read(securedStorageService).saveThemeMode(ref.read(themeModeProvider)!);
                  },
                ),
              ),
              // Header Section
              Consumer(builder: (context, ref, _) {
                final asyncProfile = ref.watch(profileProvider);

                return asyncProfile.when(
                  data: (data) {
                    Profile? profile;
                    switch (data) {
                      case Ok<Profile?>():
                        profile = data.data;
                      case Error<Profile?>():
                    }

                    return ProfileHeaderSection(
                      profile: profile,
                      isWalletConnected: false,
                      onWalletConnectTap: () async {
                        await _walletController.connectWalletToServer();
                      },
                    );
                  },
                  error: (err, stack) => WhenErrorWidget(error: err),
                  loading: () => const SizedBox(),
                );
              }),
              const VerticalSpace(AppValues.paddingLarge),
              const DividerCustom(),
              const VerticalSpace(AppValues.paddingMedium),
              // Menu Sections
              MenuSection(
                title: 'Account Settings',
                items: [
                  MenuItem(
                    icon: 'assets/icons/bank.svg',
                    title: 'KYC Verification',
                    arrowTopRight: true,
                    subtitleWidget: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'KYC Not Verified',
                        style: s12W500(context, fontFamily: interFontFamily).copyWith(
                          color: AppColors.errorLight,
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: 'assets/icons/key.svg',
                    title: 'Security',
                    subtitle: 'Change your security settings',
                    onTap: () {
                      AppNav.goRouter.push(RtNm.securityPrivacyScreen);
                    },
                  ),
                ],
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const DividerCustom(),

              const VerticalSpace(AppValues.paddingMedium),

              // // General Settings Section
              MenuSection(
                title: 'Settings',
                items: [
                  MenuItem(
                    icon: 'assets/icons/bank.svg',
                    title: 'Personal Details',
                    subtitle: 'Update your personal information',
                    onTap: () {
                      AppNav.goRouter.push(RtNm.personalDetailsScreen);
                    },
                  ),
                  MenuItem(
                    icon: 'assets/icons/bell.svg',
                    title: 'Notifications',
                    subtitle: 'Customize how you get updates',
                    onTap: () {
                      AppNav.goRouter.push(RtNm.notificationSettingsScreen);
                    },
                  ),
                  MenuItem(
                    icon: 'assets/icons/bank.svg',
                    title: 'Payment methods',
                    subtitle: 'Manage saved cards and bank accounts that linked to this account',
                    onTap: () {
                      AppNav.goRouter.push(RtNm.paymentMethodsScreen);
                    },
                  ),
                  MenuItem(
                    icon: 'assets/icons/circle_half.svg',
                    title: 'Language & Appearance',
                    subtitle: 'Customize language settings and which theme is used',
                    onTap: () {},
                  ),
                ],
              ),

              const VerticalSpace(AppValues.paddingMedium),
              const DividerCustom(),

              const VerticalSpace(AppValues.paddingMedium),

              // // Support Section
              MenuSection(
                title: 'Action & Agreements',
                items: [
                  MenuItem(
                    icon: 'assets/icons/bank.svg',
                    title: 'Referrals and rewards',
                    subtitle: 'Send and track referrals and manage your rewards',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: 'assets/icons/info.svg',
                    title: 'Agreements',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: 'assets/icons/question_mark.svg',
                    title: 'Help',
                    subtitle: 'Write a review in the app store',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: 'assets/icons/delete.svg',
                    title: 'Delete Account',
                    subtitle: 'Close your borrower account',
                    color: AppColors.errorLight,
                    onTap: () {
                      AppNav.goRouter.push(RtNm.deleteAccountScreen);
                    },
                  ),
                ],
              ),
              MenuItem(
                icon: 'assets/icons/log_out.svg',
                title: 'Logout',
                onTap: () async {
                  await ref.read(securedStorageService).deleteUserTokens();
                  AppNav.goRouter.go(RtNm.splashScreen);
                },
              ),
              // Logout Section

              const VerticalSpace(AppValues.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class DividerCustom extends StatelessWidget {
  const DividerCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.c757575.withValues(alpha: 0.3),
    );
  }
}

class ProfileHeaderSection extends StatelessWidget {
  final Profile? profile;
  final VoidCallback onWalletConnectTap;
  final bool isWalletConnected;

  const ProfileHeaderSection({
    super.key,
    this.profile,
    required this.onWalletConnectTap, required this.isWalletConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingMedium,
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
            ),
            child: Center(
              child: Text(
                '${profile?.firstName?[0].toUpperCase() ?? ''}${profile?.lastName?[0].toUpperCase() ?? ''}',
                style: s20W600(context, fontFamily: interFontFamily),
              ),
            ),
          ),
          const VerticalSpace(AppValues.paddingMedium),
          Text(
            '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}'.toUpperCase(),
            style: s22W600(context),
          ),
          const VerticalSpace(16),
          Text(
            'You are a ${profile?.userType?.toLowerCase() ?? ''}',
            style: s11W400(context),
          ),
          const VerticalSpace(16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.borderColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              profile?.isVerified() == true ? 'Verified' : 'Not Verified',
              style: s11W600(context).copyWith(
                color: AppColors.c455468,
              ),
            ),
          ),
          const VerticalSpace(16),
          AppIconButton(
            title: isWalletConnected ? 'Wallet Connected' : 'Connect Wallet',
            titleStyle: s14W500(context, fontFamily: interFontFamily).copyWith(
              color: isWalletConnected ? AppColors.primaryLight : AppColors.onBackgroundDark,
            ),
            height: 48,
            onTap: isWalletConnected ? null : onWalletConnectTap,
            icon: SvgPicture.asset('assets/icons/link.svg'),
            radius: AppValues.borderRadiusLarge,
            color: AppColors.backgroundDark,
          ),
        ],
      ),
    );
  }
}
