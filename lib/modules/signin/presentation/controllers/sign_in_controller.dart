import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/string_extension.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../more/business/repository/sign_in_repo_interface.dart';
import '../../../more/data/dto/register_dto.dart';
import '../../data/models/register_model.dart';
import '../../data/models/register_model.dart';
import '../../data/models/tokens_model.dart';

class SignInController {
  final BuildContext context;
  final WidgetRef ref;
  final SignInRepoInterface signInRepo;

  const SignInController({
    required this.context,
    required this.ref,
    required this.signInRepo,
  });

  void _handleLoginRegisterResponse({
    required Result<RegisterModel?> result,
    required String emailOrPhone,
  }) async {
    switch (result) {
      case Ok<RegisterModel?>():
        if (result.value!.userMap['isEmailVerified'] == true) {
          await ref.read(securedStorageService).saveUserTokens(result.value!.tokensModel);
          AppNav.goRouter.go(RtNm.homeScreen);
        } else {
          final otp = await AppNav.goRouter.push(RtNm.otpInputScreen, extra: emailOrPhone);
          if (otp == null) return;
          showLoadingDialog(context: context, message: 'Verifying OTP...');
          final otpVerificationResult = await signInRepo.verifyEmailOtp(
            payload: {'email': emailOrPhone, 'otp': otp},
          );
          hideDialog();
          switch (otpVerificationResult) {
            case Ok():
              await ref.read(securedStorageService).saveUserTokens(result.value!.tokensModel);
              AppNav.goRouter.go(RtNm.homeScreen);
            case Error():
              showErrorDialog(context: context, message: otpVerificationResult.toString());
          }
        }
      case Error<RegisterModel?>():
        showErrorDialog(context: context, message: result.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    AppNav.goRouter.push(RtNm.signInLoadingScreen);
    await Future.delayed(const Duration(seconds: 3));
    AppNav.navKey.currentState?.pop();
    final otp = await AppNav.goRouter.push(RtNm.otpInputScreen);
    // AppNav.goRouter.push(
    //   RtNm.userInfoInputScreen,
    //   extra: {
    //     'email': email,
    //     'password': password,
    //   },
    // );
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    AppNav.goRouter.push(RtNm.signInLoadingScreen);
    final result = await signInRepo.registerWithEmail(
      dto: RegisterDto(
        emailOrPhone: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        isEmail: true,
      ),
    );
    AppNav.navKey.currentState?.pop();

    _handleLoginRegisterResponse(result: result, emailOrPhone: email);
  }

  Future<void> resendOtp(String emailOrPhone) async {
    if (isValidEmail(emailOrPhone)) {

    } else {
      //TODO: handle resend otp for phone number
    }
  }
}
