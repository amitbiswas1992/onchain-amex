import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../controllers/sign_in_controller.dart';
import '../providers/sign_in_providers.dart';
import '../resources/signin_strings.dart';
import '../widgets/amex_text_app_bar.dart';
import '../widgets/user_consent_text.dart';

class LoginWithEmailScreen extends ConsumerStatefulWidget {
  const LoginWithEmailScreen({super.key});

  @override
  ConsumerState createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends ConsumerState<LoginWithEmailScreen> {
  late final SignInController _controller;
  final _formKey = GlobalKey<FormState>();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _controller = SignInController(
      context: context,
      ref: ref,
      signInRepo: ref.read(signInRepoProvider),
      deviceInfoService: ref.read(deviceInfoService),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
  }

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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AmexTextAppBar(),
                  const VerticalSpace(68),
                  const TitleText(
                    text: letsGetYouSignedIn,
                    textAlign: TextAlign.start,
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  AppTextFormField(
                    focusNode: _emailNode,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      size: 20,
                    ),
                    hintText: yourEmailAddress,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autoFocus: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return inputRequired;
                      }
                      if (!isValidEmail(val)) {
                        return invalidEmail;
                      }
                      return null;
                    },
                    onFieldSubmitted: (val) {
                      _passwordNode.requestFocus();
                    },
                    onSave: (val) {
                      _email = val ?? '';
                    },
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  AppTextFormField(
                    focusNode: _passwordNode,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      size: 20,
                    ),
                    hintText: password,
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onSave: (val) {
                      _password = val ?? '';
                    },
                    // validator: (val) {
                    //   if (val == null || val.isEmpty) {
                    //     return inputRequired;
                    //   }
                    //   if (val.length < 8) {
                    //     return 'Password should be 8 character long';
                    //   }
                    //   return null;
                    // },
                    validator: validatePassword,
                    onFieldSubmitted: (val) {
                      _passwordNode.unfocus();
                    },
                  ),
                  const VerticalSpace(4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        AppNav.goRouter.push(RtNm.forgotPasswordScreen);
                      },
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const VerticalSpace(24),
                  Row(
                    children: [
                      Expanded(
                        child: AppSecondaryButton(
                          title: usePhone,
                          onTap: () {
                            AppNav.goRouter
                                .pushReplacement(RtNm.loginWithPhoneScreen);
                          },
                        ),
                      ),
                      const HorizontalSpace(AppValues.paddingMedium),
                      Expanded(
                        child: AppPrimaryButton(
                          title: continuee,
                          onTap: () async {
                            HapticFeedback.lightImpact();
                            FocusScope.of(context).unfocus();
                            final valid = _formKey.currentState!.validate();
                            if (valid) {
                              _formKey.currentState!.save();
                              _controller.signIn(
                                email: _email,
                                password: _password,
                                isEmail: true,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  RichText(
                    text: TextSpan(
                      text: "Do not have an account?  ",
                      style: s14W400(context),
                      children: [
                        TextSpan(
                          text: "Register.",
                          style: s14W500(context)
                              .copyWith(color: AppColors.primaryLight),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              AppNav.goRouter
                                  .push(RtNm.registerWithEmailScreen);
                            },
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(48),
                  const UserConsentText(),
                  const VerticalSpace(40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
