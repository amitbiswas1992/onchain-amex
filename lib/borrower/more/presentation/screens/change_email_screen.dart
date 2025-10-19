import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class ChangeEmailScreen extends ConsumerStatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  ConsumerState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(text: 'reply2shakir@gmail.com');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: const PrimaryAppBar(
          title: 'Email address',
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppValues.paddingMedium),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Enter new email',
                  style: s18W600(context, fontFamily: segoeProFontFamily),
                ),
                const VerticalSpace(AppValues.paddingLarge),

                // Email input field
                AppTextFormField(
                  controller: _emailController,
                  hintText: 'Enter email address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const VerticalSpace(AppValues.paddingLarge),

                // Description text
                Text(
                  'Enter the email address you\'d like to use with your account. Please ensure that only you have access to this email to keep your account safe.',
                  style: s14W400(context, fontFamily: interFontFamily).copyWith(
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),

                const Spacer(),

                // Update button
                AppPrimaryButton(
                  title: 'Continue',
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Handle email update logic here
                      _handleEmailUpdate();
                    }
                  },
                ),
                const VerticalSpace(AppValues.paddingLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleEmailUpdate() {
    // TODO: Implement email update logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email update functionality to be implemented'),
      ),
    );
  }
}
