import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/device_info_service.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/result.dart';
import '../../business/repository/sign_in_repo_interface.dart';
import '../../data/dto/register_dto.dart';
import '../../data/models/register_model.dart';

class SignInController {
  final BuildContext context;
  final WidgetRef ref;
  final SignInRepoInterface signInRepo;
  final DeviceInfoService deviceInfoService;

  const SignInController({
    required this.context,
    required this.ref,
    required this.signInRepo,
    required this.deviceInfoService,
  });

  void _handleLoginRegisterResponse({
    required Result<RegisterModel?> result,
    required String emailOrPhone,
    required bool isEmail,
  }) async {
    switch (result) {
      case Ok<RegisterModel?>():
        if (result.data!.user.isEmailVerified ||
            result.data!.user.isPhoneVerified) {
          await ref.read(securedStorageService).saveUserModels(result.data!);
          if (result.data!.user.userType == 'LENDER') {
            AppNav.goRouter.go(RtNm.lenderHomeScreen);
          } else if (result.data!.user.userType == 'BORROWER') {
            AppNav.goRouter.go(RtNm.homeScreen);
          } else {
            AppNav.goRouter.go(RtNm.merchantHomeScreen);
          }
        } else {
          final otp = await AppNav.goRouter.push(
            RtNm.otpInputScreen,
            extra: {'emailOrPhone': emailOrPhone, 'isEmail': isEmail},
          );
          if (otp == null) return;
          showLoadingDialog(context: context, message: 'Verifying OTP...');
          final otpVerificationResult = await signInRepo.verifyEmailOtp(
            payload: {
              isEmail ? 'email' : 'phoneNumber': emailOrPhone,
              'otp': otp,
            },
            isEmail: isEmail,
          );
          hideDialog();
          switch (otpVerificationResult) {
            case Ok():
              await ref
                  .read(securedStorageService)
                  .saveUserModels(result.data!);

              if (result.data!.user.userType == 'LENDER') {
                AppNav.goRouter.go(RtNm.lenderHomeScreen);
              } else if (result.data!.user.userType == 'BORROWER') {
                AppNav.goRouter.go(RtNm.homeScreen);
              } else {
                AppNav.goRouter.go(RtNm.merchantHomeScreen);
              }
            case Error():
              showErrorDialog(
                context: context,
                message: otpVerificationResult.toString(),
              );
          }
        }
      case Error<RegisterModel?>():
        showErrorDialog(context: context, message: result.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required bool isEmail,
  }) async {
    AppNav.goRouter.push(RtNm.signInLoadingScreen);
    final result = await signInRepo.login(
      payload: {
        isEmail ? "email" : 'phoneNumber': email,
        "password": password,
        // "twoFactorCode": "123456",
        "deviceInfo": await deviceInfoService.getLoginTimeDeviceInfo(),
      },
      isEmail: isEmail,
    );
    AppNav.navKey.currentState?.pop();
    _handleLoginRegisterResponse(
      result: result,
      emailOrPhone: email,
      isEmail: isEmail,
    );
  }

  Future<void> forgotPassword({
    required String emailOrPhone,
    required bool isEmail,
  }) async {
    AppNav.goRouter.push(RtNm.signInLoadingScreen);
    final result = await signInRepo.sendPasswordResetOtp(
      payload: {isEmail ? 'email' : 'phoneNumber': emailOrPhone},
    );
    AppNav.navKey.currentState?.pop();
    switch (result) {
      case Ok():

        // Navigate to reset password screen and pass email and otp
        AppNav.goRouter.push(
          RtNm.resetPasswordScreen,
          extra: {
            'email': emailOrPhone,
          },
        );

      case Error():
        showErrorDialog(context: context, message: result.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? referralCode,
    required bool isEmail,
    required String userType,
  }) async {
    AppNav.goRouter.push(RtNm.signInLoadingScreen);
    final result = await signInRepo.registerWithEmail(
      dto: RegisterDto(
        emailOrPhone: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        referralCode: referralCode,
        isEmail: isEmail,
        userType: userType,
      ),
    );
    AppNav.navKey.currentState?.pop();

    _handleLoginRegisterResponse(
      result: result,
      emailOrPhone: email,
      isEmail: isEmail,
    );
  }

  Future<void> resendOtp({
    required String emailOrPhone,
    required bool isEmail,
  }) async {
    if (isEmail ? isValidEmail(emailOrPhone) : true) {
      final result = await signInRepo.resendOtpToEmail(
        payload: {isEmail ? 'email' : 'phoneNumber': emailOrPhone},
        isEmail: isEmail,
      );
      switch (result) {
        case Ok():
          // AppNav.goRouter.push(RtNm.otpInputScreen, extra: emailOrPhone);
          break;
        case Error():
          showErrorDialog(context: context, message: result.toString());
      }
    } else {
      //TODO: handle resend otp for phone number
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    AppNav.goRouter.push(RtNm.signInLoadingScreen);
    final result = await signInRepo.resetPassword(
      payload: {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      },
    );
    AppNav.navKey.currentState?.pop();
    switch (result) {
      case Ok():
        showSuccessDialog(
          context: context,
          message:
              'Password reset successful. Please login with your new password.',
          dismissible: false,
          onDone: () {
            AppNav.goRouter.go(RtNm.loginWithEmailScreen);
          },
        );
      case Error():
        showErrorDialog(context: context, message: result.toString());
    }
  }
}
