import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../controllers/sign_in_controller.dart';
import '../resources/signin_strings.dart';
import '../widgets/amex_text_app_bar.dart';
import '../widgets/user_consent_text.dart';

class SignInWithEmailScreen extends ConsumerStatefulWidget {
  const SignInWithEmailScreen({super.key});

  @override
  ConsumerState createState() => _SignInWithEmailScreenState();
}

class _SignInWithEmailScreenState extends ConsumerState<SignInWithEmailScreen> {

  late final SignInController _controller;
  final _formKey = GlobalKey<FormState>();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    _controller = SignInController(context: context, ref: ref);
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
                      email = val ?? '';
                    },
                  ),
                  const VerticalSpace(AppValues.paddingLarge),
                  AppTextFormField(
                    focusNode: _passwordNode,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      size: 20,
                    ),
                    hintText: enterTheCode,
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  const VerticalSpace(32),
                  Row(
                    children: [
                      Expanded(
                        child: AppSecondaryButton(
                          title: usePhone,
                          onTap: () {
                            AppNav.goRouter.pushReplacement(RtNm.signInWithPhoneScreen);
                          },
                        ),
                      ),
                      const HorizontalSpace(AppValues.paddingMedium),
                      Expanded(
                        child: AppPrimaryButton(
                          title: continuee,
                          onTap: () async {
                            _controller.signIn();
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
