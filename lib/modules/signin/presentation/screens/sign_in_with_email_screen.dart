import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../resources/signin_strings.dart';
import '../widgets/amex_text_app_bar.dart';

class SignInWithEmailScreen extends ConsumerStatefulWidget {
  const SignInWithEmailScreen({super.key});

  @override
  ConsumerState createState() => _SignInWithEmailScreenState();
}

class _SignInWithEmailScreenState extends ConsumerState<SignInWithEmailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.paddingMedium,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AmexTextAppBar(),
                const VerticalSpace(68),
                const TitleText(
                  text: SignInStrings.letsGetYpuSignedIn,
                  textAlign: TextAlign.start,
                ),
                const VerticalSpace(AppValues.paddingMedium),
                const AppTextFormField(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    size: 20,
                  ),
                  hintText: SignInStrings.yourEmailAddress,
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  autoFocus: true,
                ),
                const VerticalSpace(32),
                Row(
                  children: [
                    const Expanded(
                      child: AppButton(
                        title: SignInStrings.usePhone,
                        color: AppColors.cF5F5F5,
                        titleColor: AppColors.onBackgroundLight,
                        showBorder: true,
                      ),
                    ),
                    const HorizontalSpace(AppValues.paddingMedium),
                    Expanded(
                      child: AppButton(
                        title: SignInStrings.continuee,
                        onTap: () async {
                          AppNav.goRouter.push(RtNm.signInLoadingScreen);
                          await Future.delayed(const Duration(seconds: 5));
                          AppNav.navKey.currentState?.pop();
                        },
                      ),
                    ),
                  ],
                ),
                const VerticalSpace(82),
                RichText(
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
                ),
                const VerticalSpace(40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
