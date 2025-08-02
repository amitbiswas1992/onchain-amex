import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../resources/signin_strings.dart';
import '../widgets/amex_text_app_bar.dart';
import '../widgets/user_consent_text.dart';

class SignInWithEmailScreen extends ConsumerStatefulWidget {
  const SignInWithEmailScreen({super.key});

  @override
  ConsumerState createState() => _SignInWithEmailScreenState();
}

class _SignInWithEmailScreenState extends ConsumerState<SignInWithEmailScreen> {
  @override
  Widget build(BuildContext context) {
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
                    Expanded(
                      child: AppSecondaryButton(
                        title: SignInStrings.usePhone,
                        onTap: () {
                          AppNav.goRouter.pushReplacement(RtNm.signInWithPhoneScreen);
                        },
                      ),
                    ),
                    const HorizontalSpace(AppValues.paddingMedium),
                    Expanded(
                      child: AppPrimaryButton(
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
                const UserConsentText(),
                const VerticalSpace(40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
