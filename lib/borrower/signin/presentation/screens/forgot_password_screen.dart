import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../controllers/sign_in_controller.dart';
import '../providers/sign_in_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailNode = FocusNode();
  String _email = '';
  bool _loading = false;

  @override
  void dispose() {
    _emailNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    _formKey.currentState?.save();
    setState(() => _loading = true);

    final controller = SignInController(
      context: context,
      ref: ref,
      signInRepo: ref.read(signInRepoProvider),
      deviceInfoService: ref.read(deviceInfoService),
    );

    await controller.forgotPassword(emailOrPhone: _email, isEmail: true);

    setState(() => _loading = false);
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.paddingMedium),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpace(24),
                const TitleText(
                  text: 'Forgot password',
                  textAlign: TextAlign.start,
                ),
                const VerticalSpace(AppValues.paddingMedium),
                AppTextFormField(
                  focusNode: _emailNode,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    size: 20,
                  ),
                  hintText: 'Email address',
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!isValidEmail(val)) return 'Enter a valid email';
                    return null;
                  },
                  onSave: (val) => _email = val ?? '',
                ),
                const Spacer(),
                SafeArea(
                  child: AppPrimaryButton(
                    title: _loading ? 'Processing...' : 'Continue',
                    onTap: _loading ? null : _submit,
                  ),
                ),
                const VerticalSpace(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
