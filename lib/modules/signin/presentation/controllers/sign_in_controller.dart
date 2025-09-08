import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/string_extension.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../more/business/repository/sign_in_repo_interface.dart';
import '../../../more/data/dto/register_dto.dart';
import '../../../more/data/models/tokens_model.dart';

class SignInController {
  final BuildContext context;
  final WidgetRef ref;
  final SignInRepoInterface signInRepo;

  const SignInController({
    required this.context,
    required this.ref,
    required this.signInRepo,
  });

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    AppNav.goRouter.push(RtNm.signInLoadingScreen);
    await Future.delayed(const Duration(seconds: 3));
    AppNav.navKey.currentState?.pop();
    final otp = await AppNav.goRouter.push(RtNm.otpInputScreen);
    AppNav.goRouter.push(
      RtNm.userInfoInputScreen,
      extra: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    AppNav.goRouter.push(RtNm.signInLoadingScreen);
    final result = await signInRepo.register(
      dto: RegisterDto(
        emailOrPhone: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        isEmail: true,
      ),
    );
    AppNav.navKey.currentState?.pop();

    switch (result) {
      case Ok<TokensModel?>():
        await ref.read(securedStorageService).saveUserTokens(result.value!);
        AppNav.goRouter.go(RtNm.homeScreen);
      case Error<TokensModel?>():
        showErrorDialog(context: context, message: result.toString());
    }
  }
}
