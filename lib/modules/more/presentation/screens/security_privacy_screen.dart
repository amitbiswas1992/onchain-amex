import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../widgets/menu_section.dart';

class SecurityPrivacyScreen extends ConsumerStatefulWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  ConsumerState createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends ConsumerState<SecurityPrivacyScreen> {
  bool _biometricDataEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: isLightTheme(context)
      //     ? const Color.fromARGB(255, 255, 255, 255)
      //     : const Color(0xFF121212),
      appBar: const PrimaryAppBar(
        title: 'Security & Privacy',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Settings Section
            Text(
              'Security Settings',
              style: s18W600(context, fontFamily: segoeProFontFamily),
            ),
            const VerticalSpace(AppValues.paddingMedium),

            const SecuritySettingsSection(),

            const VerticalSpace(AppValues.paddingLarge),

            // Privacy Settings Section
            Text(
              'Privacy Settings',
              style: s18W600(context, fontFamily: segoeProFontFamily),
            ),
            const VerticalSpace(AppValues.paddingMedium),

            PrivacySettingsSection(
              biometricDataEnabled: _biometricDataEnabled,
              onBiometricToggle: (value) {
                setState(() {
                  _biometricDataEnabled = value;
                });
              },
            ),

            const VerticalSpace(AppValues.paddingLarge),
          ],
        ),
      ),
    );
  }
}

class SecuritySettingsSection extends StatelessWidget {
  const SecuritySettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuSection(
      items: [
        // MenuItem(
        //   icon: 'assets/icons/fingerprint.svg',
        //   title: '2-step verification',
        //   subtitle: 'Status: on',
        //   onTap: () {
        //     // Navigate to 2-step verification settings
        //   },
        // ),
        MenuItem(
          icon: 'assets/icons/phone.svg',
          title: 'Devices',
          subtitle: 'Manage your devices',
          onTap: () {
            AppNav.goRouter.push(RtNm.manageDevicesScreen);
          },
        ),
        MenuItem(
          icon: 'assets/icons/circle_half.svg',
          title: 'Language & appearance',
          subtitle: 'Customize language settings and which theme is used',
          onTap: () {
            AppNav.goRouter.push(RtNm.languageAndAppearanceScreen);
          },
        ),
      ],
    );
  }
}

class PrivacySettingsSection extends StatelessWidget {
  final bool biometricDataEnabled;
  final ValueChanged<bool> onBiometricToggle;

  const PrivacySettingsSection({
    super.key,
    required this.biometricDataEnabled,
    required this.onBiometricToggle,
  });

  @override
  Widget build(BuildContext context) {
    return MenuSection(
      items: [
        BiometricToggleMenuItem(
          assetPath: 'assets/icons/fingerprint.svg',
          title: 'Biometric data',
          subTitle: 'Allow $appTitle to store and use your selfie & ID for automated verification',
          enabled: biometricDataEnabled,
          onToggle: onBiometricToggle,
        ),
        MenuItem(
          icon: 'assets/icons/notebook.svg',
          title: 'Privacy policy',
          subtitle: 'Read about our privacy policy',
          onTap: () {
            // Navigate to privacy policy
          },
        ),
      ],
    );
  }
}

class BiometricToggleMenuItem extends StatelessWidget {
  final String assetPath;
  final String title;
  final String subTitle;
  final bool enabled;
  final ValueChanged<bool> onToggle;

  const BiometricToggleMenuItem({
    super.key,
    required this.enabled,
    required this.onToggle,
    required this.assetPath,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.borderColor.withValues(alpha: 0.2),
            ),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            assetPath,
            color: Theme.of(context).iconTheme.color,
            width: 24,
            height: 24,
          ),
        ),
        const HorizontalSpace(AppValues.paddingMedium),

        // Title and subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: s16W500(context, fontFamily: interFontFamily),
              ),
              const VerticalSpace(4),
              Text(
                subTitle,
                style: s14W400(context, fontFamily: interFontFamily).copyWith(
                  color: Colors.grey.shade600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        const HorizontalSpace(AppValues.paddingSmall),

        // Toggle switch
        Switch(
          value: enabled,
          onChanged: onToggle,
          activeColor: Colors.white,
          activeTrackColor: Colors.green,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}
