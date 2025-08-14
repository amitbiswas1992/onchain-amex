import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';

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
      backgroundColor: isLightTheme(context)
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              VerticalSpace(padding.top + AppValues.paddingMedium),
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
                        style: s12W500(context, fontFamily: interFontFamily)
                            .copyWith(
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
                    onTap: () {},
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
                    title: 'Payment Details',
                    subtitle: 'Update your personal information',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: 'assets/icons/bell.svg',
                    title: 'Notifications',
                    subtitle: 'Customize how you get updates',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: 'assets/icons/bank.svg',
                    title: 'Payment methods',
                    subtitle:
                        'Manage saved cards and bank accounts that linked to this account',
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: 'assets/icons/circle_half.svg',
                    title: 'Language & Appearance',
                    subtitle:
                        'Customize language settings and which theme is used',
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
                    subtitle:
                        'Send and track referrals and manage your rewards',
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
                    onTap: () {},
                  ),
                ],
              ),
              MenuItem(
                icon: 'assets/icons/log_out.svg',
                title: 'Logout',
                onTap: () {},
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
            onTap: () {},
            icon: SvgPicture.asset('assets/icons/link.svg'),
            radius: AppValues.borderRadiusLarge,
            color: AppColors.backgroundDark,
          ),
        ],
      ),
    );
  }
}

class MenuSection extends StatelessWidget {
  final String? title;
  final List<MenuItem> items;

  const MenuSection({
    super.key,
    this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: s18W600(
              context,
              fontFamily: segoeProFontFamily,
            ),
          ),
        ],
        const VerticalSpace(AppValues.paddingMedium),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          // separatorBuilder: (context, index) =>
          //     const VerticalSpace(AppValues.paddingSmall),
          itemBuilder: (context, index) => items[index],
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final VoidCallback onTap;
  final Color? color;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitleWidget,
    this.subtitle,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: color ?? AppColors.borderColor.withValues(alpha: 0.2),
                ),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                icon,
                color: color ?? Theme.of(context).iconTheme.color,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: s14W600(context).copyWith(
                      color: color,
                    ),
                  ),
                  if (subtitle != null || subtitleWidget != null) ...[
                    const SizedBox(height: 4),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 3,
                        style: s12W400(context).copyWith(
                          color: color,
                        ),
                      ),
                    if (subtitleWidget != null) subtitleWidget!,
                  ],
                ],
              ),
            ),
            title.contains('KYC')
                ? SvgPicture.asset('assets/icons/arrow_up_right.svg')
                : const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.c455468,
                  ),
          ],
        ),
      ),
    );
  }
}
