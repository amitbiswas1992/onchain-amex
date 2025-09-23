import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/services/secured_storage_service.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/theme_toogle_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../connect_wallet/presentation/screens/connect_wallet_screen.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../widgets/menu_section.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
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
              const ProfileHeaderSection(),
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
  const ProfileHeaderSection({
    super.key,
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
                'SH',
                style: s20W600(context, fontFamily: interFontFamily),
              ),
            ),
          ),
          const VerticalSpace(AppValues.paddingMedium),
          Text(
            'Shakir Ahmed'.toUpperCase(),
            style: s22W600(context),
          ),
          const VerticalSpace(16),
          Text(
            'You are a borrower',
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
              'Not Verified',
              style: s11W600(context).copyWith(
                color: AppColors.c455468,
              ),
            ),
          ),
          const VerticalSpace(16),
          AppIconButton(
            title: 'Connect Wallet',
            titleStyle: s14W500(context, fontFamily: interFontFamily).copyWith(
              color: AppColors.onBackgroundDark,
            ),
            height: 48,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ConnectWalletScreen()));
            },
            icon: SvgPicture.asset('assets/icons/link.svg'),
            radius: AppValues.borderRadiusLarge,
            color: AppColors.backgroundDark,
          ),
        ],
      ),
    );
  }
}
