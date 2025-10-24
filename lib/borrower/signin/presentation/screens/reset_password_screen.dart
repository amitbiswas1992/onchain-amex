import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../controllers/sign_in_controller.dart';
import '../providers/sign_in_providers.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? email;

  const ResetPasswordScreen({super.key, this.email});

  @override
  ConsumerState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailNode = FocusNode();
  final _otpNode = FocusNode();
  final _passwordNode = FocusNode();
  final _confirmNode = FocusNode();

  String _email = '';
  String _otp = '';
  String _password = '';
  String _confirm = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _email = widget.email ?? '';
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _otpNode.dispose();
    _passwordNode.dispose();
    _confirmNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;
    _formKey.currentState?.save();
    if (_password != _confirm) {
      showErrorDialog(context: context, message: 'Passwords do not match');
      return;
    }
    setState(() => _loading = true);

    final controller = SignInController(
      context: context,
      ref: ref,
      signInRepo: ref.read(signInRepoProvider),
      deviceInfoService: ref.read(deviceInfoService),
    );

    await controller.resetPassword(
      email: _email,
      otp: _otp,
      newPassword: _password,
    );

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.paddingMedium),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpace(24),
                  const TitleText(
                    text: 'Reset password',
                    textAlign: TextAlign.start,
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  const VerticalSpace(AppValues.paddingMedium),
                  AppTextFormField(
                    focusNode: _otpNode,
                    prefixIcon:
                        const Icon(Icons.confirmation_num_outlined, size: 20),
                    hintText: 'OTP',
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Please enter OTP';
                      return null;
                    },
                    onSave: (val) => _otp = val ?? '',
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  AppTextFormField(
                    focusNode: _passwordNode,
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    hintText: 'New password',
                    maxLines: 1,
                    obscureText: true,
                    validator: validatePassword,
                    onSave: (val) => _password = val ?? '',
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  AppTextFormField(
                    focusNode: _confirmNode,
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    hintText: 'Confirm password',
                    maxLines: 1,
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Please confirm password';
                      return null;
                    },
                    onSave: (val) => _confirm = val ?? '',
                  ),
                  const VerticalSpace(24),
                  AppPrimaryButton(
                    title: _loading ? 'Submitting...' : 'Reset password',
                    onTap: _loading ? null : _submit,
                  ),
                  const VerticalSpace(24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
