import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
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
import '../../../../core/widgets/phone_number_text_field.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../providers/sign_in_providers.dart';
import '../resources/signin_strings.dart';
import '../widgets/amex_text_app_bar.dart';
import '../widgets/user_consent_text.dart';

class SignInWithPhoneScreen extends ConsumerStatefulWidget {
  const SignInWithPhoneScreen({super.key});

  @override
  ConsumerState createState() => _SignInWithPhoneScreenState();
}

class _SignInWithPhoneScreenState extends ConsumerState<SignInWithPhoneScreen> {
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
                Consumer(
                  builder: (context, ref, _) {
                    final countryCode = ref.watch(selectedCountryCodeProvider);

                    return PhoneNumberTextField(
                      countryCode: countryCode,
                      onCountryCodeChanged: (code) {
                        ref.read(selectedCountryCodeProvider.notifier).state = code;
                      },
                      prefixIcon: const Icon(
                        CupertinoIcons.device_phone_portrait,
                        size: 20,
                      ),
                      autoFocus: true,
                    );
                  },
                ),
                const VerticalSpace(32),
                Row(
                  children: [
                    Expanded(
                      child: AppSecondaryButton(
                        title: SignInStrings.useEmail,
                        onTap: () {
                          AppNav.goRouter.pushReplacement(RtNm.signInWithEmailScreen);
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
