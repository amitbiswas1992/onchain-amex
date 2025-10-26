import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/theme_toogle_button.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/errors/when_error_widget.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../signin/presentation/providers/sign_in_providers.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import '../../data/models/profile.dart';
import '../providers/more_providers.dart';
import '../widgets/connect_wallet_button.dart';
import '../widgets/menu_section.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  String _merchantMode = 'Merchant'; // Default mode

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMerchantMode();
    });
  }

  Future<void> _loadMerchantMode() async {
    final mode = await ref.read(securedStorageService).getMerchantMode();
    if (mode != null && mounted) {
      setState(() {
        _merchantMode = mode;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: 60,
        onRefresh: () async {
          ref.invalidate(profileProvider);
          await Future.delayed(const Duration(milliseconds: 1000));
        },
        child: Consumer(
          builder: (context, ref, _) {
            final asyncProfile = ref.watch(profileProvider);

            return asyncProfile.when(
              data: (data) {
                Profile? profile;
                switch (data) {
                  case Ok<Profile?>():
                    profile = data.data;
                  case Error<Profile?>():
                }

                return MoreBody(
                  profile: profile,
                  merchantMode: _merchantMode,
                  onMerchantModeChanged: (mode) async {
                    setState(() {
                      _merchantMode = mode;
                    });
                    await Future.delayed(const Duration(milliseconds: 300));
                    await ref
                        .read(securedStorageService)
                        .saveMerchantMode(mode);
                    if (mounted) {
                      AppNav.goRouter.go(RtNm.splashScreen);
                    }
                  },
                );
              },
              error: (err, stack) => WhenErrorWidget(error: err),
              loading: () => MoreBody(
                profile: null,
                merchantMode: _merchantMode,
                onMerchantModeChanged: (mode) {},
              ),
            );
          },
        ),
      ),
    );
  }
}

class MoreBody extends ConsumerWidget {
  final Profile? profile;
  final String merchantMode;
  final Function(String) onMerchantModeChanged;

  const MoreBody({
    super.key,
    required this.profile,
    required this.merchantMode,
    required this.onMerchantModeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = MediaQuery.of(context).padding;
    return Padding(
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
                  ref.read(themeModeProvider.notifier).state =
                      isLightTheme(context) ? ThemeMode.dark : ThemeMode.light;
                  ref
                      .read(securedStorageService)
                      .saveThemeMode(ref.read(themeModeProvider)!);
                },
              ),
            ),
            // Header Section
            ProfileHeaderSection(
              profile: profile,
            ),
            const VerticalSpace(AppValues.paddingLarge),
            const DividerCustom(),
            const VerticalSpace(AppValues.paddingMedium),
            // Mode Toggle Section - Only for MERCHANT users
            if (profile?.userType == 'MERCHANT') ...[
              MenuSection(
                title: 'App Mode',
                items: [
                  MenuItemToggle(
                    icon: icon,
                    title: 'Switch Mode',
                    subtitle: 'Toggle between Lender and Merchant mode',
                    option1: 'Lender',
                    option2: 'Merchant',
                    currentValue: merchantMode,
                    onChanged: onMerchantModeChanged,
                  ),
                ],
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const DividerCustom(),
              const VerticalSpace(AppValues.paddingMedium),
            ],
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
                      profile?.kycStatus == "APPROVED"
                          ? 'Verified'
                          : 'KYC Not Verified',
                      style: s12W500(context, fontFamily: interFontFamily)
                          .copyWith(
                        color: profile?.kycStatus == "APPROVED"
                            ? AppColors.primaryVariantLight
                            : AppColors.errorLight,
                      ),
                    ),
                  ),
                  onTap: () {
                    // if (profile?.kycStatus == "APPROVED") return;
                    AppNav.goRouter.push(RtNm.kycScreen);
                  },
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
                    if (profile != null) {
                      AppNav.goRouter
                          .push(RtNm.personalDetailsScreen, extra: profile);
                    }
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
                // MenuItem(
                //   icon: 'assets/icons/bank.svg',
                //   title: 'Payment methods',
                //   subtitle: 'Manage saved cards and bank accounts that linked to this account',
                //   onTap: () {
                //     AppNav.goRouter.push(RtNm.paymentMethodsScreen);
                //   },
                // ),
                MenuItem(
                  icon: 'assets/icons/circle_half.svg',
                  title: 'Language & Appearance',
                  subtitle:
                      'Customize language settings and which theme is used',
                  onTap: () {
                    AppNav.goRouter.push(RtNm.languageAndAppearanceScreen);
                  },
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
                // MenuItem(
                //   icon: 'assets/icons/bank.svg',
                //   title: 'Referrals and rewards',
                //   subtitle: 'Send and track referrals and manage your rewards',
                //   onTap: () {},
                // ),
                MenuItem(
                  icon: 'assets/icons/info.svg',
                  title: 'Terms & Conditions',
                  subtitle: 'Read the app terms and conditions',
                  onTap: () async {
                    await launchLink(
                      termsAndConditionsUrl,
                      context,
                    );
                  },
                ),
                MenuItem(
                  icon: 'assets/icons/privacy.svg',
                  subtitle: 'Read the app privacy policy',
                  title: 'Privacy Policy',
                  onTap: () async {
                    await launchLink(
                      privacyPolicyUrl,
                      context,
                    );
                  },
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
                    if (profile != null) {
                      AppNav.goRouter
                          .push(RtNm.deleteAccountScreen, extra: profile);
                    } else {
                      log('profile is null');
                    }
                  },
                ),
              ],
            ),
            MenuItem(
              icon: 'assets/icons/log_out.svg',
              title: 'Logout',
              onTap: () async {
                final logout = await showPermissionDialog(
                  context: context,
                  message: 'Your account will be logged out.',
                );
                if (logout != true) return;
                showLoadingDialog(context: context);
                final result = await ref.read(signInRepoProvider).logout();
                hideDialog();
                switch (result) {
                  case Ok():
                    await ref.read(securedStorageService).deleteUserTokens();
                    await ref.read(securedStorageService).deleteMerchantMode();
                    await ref
                        .read(appkitModalProvider)
                        .valueOrNull
                        ?.disconnect();

                    AppNav.goRouter.go(RtNm.splashScreen);
                    ref.invalidate(profileProvider);
                    ref.invalidate(appkitModalProvider);
                    ref.invalidate(walletRepoProvider);
                    ref.invalidate(devicesRepo);
                  case Error():
                    showErrorDialog(
                      context: context,
                      message: result.toString(),
                    );
                }
              },
            ),
            // Logout Section

            const VerticalSpace(AppValues.paddingLarge),
          ],
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

  const ProfileHeaderSection({
    super.key,
    this.profile,
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
                profile?.getShortName() ?? '',
                style: s20W600(context, fontFamily: interFontFamily),
              ),
            ),
          ),
          const VerticalSpace(AppValues.paddingMedium),
          profile == null
              ? Skeletonizer(
                  child: Text(
                    '__________',
                    style: s22W600(context),
                  ),
                )
              : const SizedBox.shrink(),
          if (profile != null) ...[
            Text(
              '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}'
                  .toUpperCase(),
              style: s22W600(context),
            ),
            const VerticalSpace(8),
            Text(
              'You are a ${profile?.userType?.toLowerCase() ?? ''}',
              style: s11W400(context),
            ),
          ],
          const VerticalSpace(8),
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
          const VerticalSpace(8),
          if (profile == null)
            Skeletonizer(
              child: Skeleton.leaf(
                child: Container(
                  width: 150,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
            ),
          if (profile != null) ConnectWalletButton(profile: profile!),
        ],
      ),
    );
  }
}
