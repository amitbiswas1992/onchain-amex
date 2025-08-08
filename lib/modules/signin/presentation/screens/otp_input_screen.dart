import 'package:flutter/material.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../resources/signin_strings.dart';
import '../widgets/amex_text_app_bar.dart';

class OtpInputScreen extends StatefulWidget {
  const OtpInputScreen({super.key});

  @override
  State<OtpInputScreen> createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends State<OtpInputScreen> {
  final _otpNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  String otp = '';

  @override
  void dispose() {
    _otpNode.dispose();
    super.dispose();
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AmexTextAppBar(),
                const VerticalSpace(68),
                const TitleText(
                  text: SignInStrings.enterTheCode,
                  textAlign: TextAlign.start,
                ),
                const VerticalSpace(AppValues.paddingMedium),
                Text(
                  SignInStrings.weHaveSentACodeTo,
                  style: s14W400(context),
                ),
                const VerticalSpace(AppValues.paddingMedium),
                AppTextFormField(
                  focusNode: _otpNode,
                  controller: _otpController,
                  hintText: SignInStrings.confirmationCode,
                ),
                const Expanded(child: SizedBox()),
                SafeArea(
                  child: AppPrimaryButton(
                    title: SignInStrings.continuee,
                    onTap: () {
                      AppNav.goRouter.pop(_otpController.text);
                    },
                  ),
                ),
                const VerticalSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
