import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/app_colors.dart';
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
              ..onTap = () {
                // Handle Terms and Conditions tap
                print('Tapped Terms and Conditions');
              },
          ),
          const TextSpan(text: ', '),
          TextSpan(
            text: 'E-Consents',
            style: s12W400(context).copyWith(
              color: isLightTheme(context)
                  ? AppColors.onBackgroundLight
                  : AppColors.onBackgroundDark,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle E-Consents tap
                print('Tapped E-Consents');
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
              ..onTap = () {
                // Handle Privacy Policy tap
                print('Tapped Privacy Policy');
              },
          ),
          TextSpan(
            text: ' of Amex On Chain.',
            style: s12W400(context),
          ),
        ],
      ),
    );
  }
}
