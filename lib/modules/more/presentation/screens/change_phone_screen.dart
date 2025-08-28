import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/phone_number_text_field.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../signin/presentation/providers/sign_in_providers.dart';

class ChangePhoneScreen extends ConsumerStatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  ConsumerState createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends ConsumerState<ChangePhoneScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: const PrimaryAppBar(
          title: 'Phone number',
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
                  'Enter new phone number',
                  style: s18W600(context, fontFamily: segoeProFontFamily),
                ),
                const VerticalSpace(AppValues.paddingLarge),

                // Phone input field with country selector
                Consumer(
                  builder: (context, ref, _) {
                    final countryCode = ref.watch(selectedCountryCodeProvider);

                    return PhoneNumberTextField(
                      countryCode: countryCode,
                      onCountryCodeChanged: (code) {
                        ref.read(selectedCountryCodeProvider.notifier).state =
                            code;
                      },
                      prefixIcon: const Icon(
                        CupertinoIcons.device_phone_portrait,
                        size: 20,
                      ),
                      autoFocus: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Phone number is required';
                        }
                        if (value!.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const VerticalSpace(AppValues.paddingLarge),

                // Description text
                Text(
                  'We will send you an OTP to verify this number',
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
                      // Handle phone update logic here
                      _handlePhoneUpdate();
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

  void _handlePhoneUpdate() {
    // TODO: Implement phone update logic
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Phone number update functionality to be implemented'),
    //   ),
    // );
    AppNav.goRouter.push(RtNm.otpInputScreen);
  }
}
