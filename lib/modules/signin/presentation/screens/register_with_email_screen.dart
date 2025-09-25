import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../controllers/sign_in_controller.dart';
import '../providers/sign_in_providers.dart';
import '../resources/signin_strings.dart';
import '../widgets/amex_text_app_bar.dart';
import '../widgets/user_consent_text.dart';

class RegisterWithEmailScreen extends ConsumerStatefulWidget {
  const RegisterWithEmailScreen({super.key});

  @override
  ConsumerState createState() => _SignInWithEmailScreenState();
}

class _SignInWithEmailScreenState extends ConsumerState<RegisterWithEmailScreen> {
  late final SignInController _controller;
  final _formKey = GlobalKey<FormState>();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final _firstNameNode = FocusNode();
  final _lastNameNode = FocusNode();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _controller = SignInController(
      context: context,
      ref: ref,
      signInRepo: ref.read(signInRepoProvider),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    _firstNameNode.dispose();
    _lastNameNode.dispose();
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
                    text: letsGetYpuSignedIn,
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
                      _firstNameNode.requestFocus();
                    },
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  AppTextFormField(
                    focusNode: _firstNameNode,
                    hintText: firstName,
                    prefixIcon: const Icon(CupertinoIcons.person),
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (value) {
                      _lastNameNode.requestFocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return inputRequired;
                      }
                      return null;
                    },
                    onSave: (val) {
                      _firstName = val ?? '';
                    },
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  AppTextFormField(
                    focusNode: _lastNameNode,
                    hintText: lastName,
                    prefixIcon: const Icon(CupertinoIcons.person),
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (value) {
                      _lastNameNode.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return inputRequired;
                      }
                      return null;
                    },
                    onSave: (val) {
                      _lastName = val ?? '';
                    },
                  ),
                  const VerticalSpace(32),
                  Row(
                    children: [
                      Expanded(
                        child: AppSecondaryButton(
                          title: usePhone,
                          onTap: () {
                            AppNav.goRouter.pushReplacement(RtNm.registerWithPhoneScreen);
                          },
                        ),
                      ),
                      const HorizontalSpace(AppValues.paddingMedium),
                      Expanded(
                        child: AppPrimaryButton(
                          title: continuee,
                          onTap: () async {
                            final valid = await _formKey.currentState!.validate();
                            if (valid) {
                              _formKey.currentState!.save();
                              _controller.register(
                                email: _email,
                                password: _password,
                                lastName: _lastName,
                                firstName: _firstName,
                                isEmail: true,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(AppValues.paddingLarge),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account?  ",
                      style: s14W400(context),
                      children: [
                        TextSpan(
                          text: "Login.",
                          style: s14W500(context),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              AppNav.goRouter.push(RtNm.loginWithEmailScreen);
                            },
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(82),
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
