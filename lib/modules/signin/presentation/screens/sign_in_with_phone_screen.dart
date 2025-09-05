import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/phone_number_text_field.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../controllers/sign_in_controller.dart';
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
  late final SignInController _controller;

  final _formKey = GlobalKey<FormState>();
  final _phoneNode = FocusNode();
  final _passwordNode = FocusNode();
  String _phone = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _controller = SignInController(context: context, ref: ref);
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNode.dispose();
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
                    text: letsGetYpuSignedIn,
                    textAlign: TextAlign.start,
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  Consumer(
                    builder: (context, ref, _) {
                      final countryCode = ref.watch(selectedCountryCodeProvider);

                      return PhoneNumberTextField(
                        focusNode: _phoneNode,
                        countryCode: countryCode,
                        onCountryCodeChanged: (code) {
                          ref.read(selectedCountryCodeProvider.notifier).state = code;
                        },
                        prefixIcon: const Icon(
                          CupertinoIcons.device_phone_portrait,
                          size: 20,
                        ),
                        autoFocus: true,
                        onFieldSubmitted: (val) {
                          _passwordNode.requestFocus();
                        },
                        onSave: (val) {
                          _phone = val ?? '';
                        },
                      );
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
                  ),
                  const VerticalSpace(32),
                  Row(
                    children: [
                      Expanded(
                        child: AppSecondaryButton(
                          title: useEmail,
                          onTap: () {
                            AppNav.goRouter.pushReplacement(RtNm.signInWithEmailScreen);
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
                              _controller.signIn(email: _phone, password: _password);
                            }
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
      ),
    );
  }
}
