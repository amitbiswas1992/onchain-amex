import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../controllers/sign_in_controller.dart';
import '../providers/sign_in_providers.dart';
import '../resources/signin_strings.dart';
import '../widgets/amex_text_app_bar.dart';

class OtpInputScreen extends ConsumerStatefulWidget {
  final String emailOrPhone;
  final bool isEmail;

  const OtpInputScreen({
    super.key,
    required this.emailOrPhone,
    required this.isEmail,
  });

  @override
  ConsumerState<OtpInputScreen> createState() => _OtpInputScreenState();
}

class _OtpInputScreenState extends ConsumerState<OtpInputScreen> {
  late final SignInController _controller;
  final _otpNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  String otp = '';

  @override
  void initState() {
    _controller = SignInController(
      context: context,
      signInRepo: ref.read(signInRepoProvider),
      ref: ref,
      deviceInfoService: ref.read(deviceInfoService),
    );
    super.initState();
  }

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
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AmexTextAppBar(),
                        const VerticalSpace(68),
                        const TitleText(
                          text: enterTheCode,
                          textAlign: TextAlign.start,
                        ),
                        const VerticalSpace(AppValues.paddingMedium),
                        Text(
                          'We’ve sent a code to ‘${widget.emailOrPhone}’',
                          style: s14W400(context),
                        ),
                        const VerticalSpace(AppValues.paddingMedium),
                        AppTextFormField(
                          focusNode: _otpNode,
                          controller: _otpController,
                          hintText: confirmationCode,
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'OTP should be 6 digit';
                            }

                            return null;
                          },
                          onFieldSubmitted: (val) {
                            _otpNode.unfocus();
                          },
                        ),
                        const VerticalSpace(AppValues.paddingSmall),
                        OtpResendTimer(
                          onResend: () {
                            _controller.resendOtp(
                              emailOrPhone: widget.emailOrPhone,
                              isEmail: widget.isEmail,
                            );
                          },
                          initialDuration: const Duration(minutes: 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // const Expanded(child: SizedBox()),
                Column(
                  children: [
                    AppPrimaryButton(
                      title: continuee,
                      onTap: () {

                        final valid = _formKey.currentState!.validate();
                        if (!valid) {
                          return;
                        }
                        AppNav.goRouter.pop(_otpController.text);
                      },
                    ),
                    const VerticalSpace(20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtpResendTimer extends StatefulWidget {
  final Duration initialDuration;
  final VoidCallback onResend;

  const OtpResendTimer({
    super.key,
    this.initialDuration = const Duration(seconds: 30),
    required this.onResend,
  });

  @override
  State<OtpResendTimer> createState() => _OtpResendTimerState();
}

class _OtpResendTimerState extends State<OtpResendTimer> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _remaining = widget.initialDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 1) {
        timer.cancel();
        setState(() => _remaining = Duration.zero);
      } else {
        setState(() {
          _remaining = Duration(seconds: _remaining.inSeconds - 1);
        });
      }
    });
  }

  void _handleResend() {
    widget.onResend(); // trigger API
    _startTimer(); // restart countdown
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _remaining == Duration.zero
        ? TextButton(
            onPressed: _handleResend,
            child: Text(
              "Resend OTP",
              style: TextStyle(
                color: isLightTheme(context) ? Colors.black : Colors.white,
                decoration: TextDecoration.underline,
                decorationColor: isLightTheme(context) ? Colors.black : Colors.white,
              ),
            ),
          )
        : Text(
            "Resend OTP in ${_formatDuration(_remaining)}",
            style: TextStyle(color: isLightTheme(context) ? Colors.black : Colors.white),
          );
  }
}
