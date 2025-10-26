import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class UserConsentText extends StatelessWidget {
  const UserConsentText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: s12W400(context),
        children: [
          const TextSpan(text: 'By tapping “Continue” you agree to the '),
          TextSpan(
            text: 'Terms and Conditions',
            style: s12W400(context).copyWith(
              color: isLightTheme(context)
                  ? AppColors.onBackgroundLight
                  : AppColors.onBackgroundDark,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await launchLink(
                  termsAndConditionsUrl,
                  context,
                );
              },
          ),
          TextSpan(
            text: ' and ',
            style: s12W400(context),
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: s12W400(context).copyWith(
              color: isLightTheme(context)
                  ? AppColors.onBackgroundLight
                  : AppColors.onBackgroundDark,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                await launchLink(
                  privacyPolicyUrl,
                  context,
                );
              },
          ),
          TextSpan(
            text: ' of $appTitle.',
            style: s12W400(context),
          ),
        ],
      ),
    );
  }
}
