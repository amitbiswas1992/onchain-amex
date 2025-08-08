import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/string_extension.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';

class SignInController {
  final BuildContext context;
  final WidgetRef ref;

  const SignInController({required this.context, required this.ref});

  Future<void> signIn() async {
    AppNav.goRouter.push(RtNm.signInLoadingScreen);
    await Future.delayed(const Duration(seconds: 3));
    AppNav.navKey.currentState?.pop();
    final otp = await AppNav.goRouter.push(RtNm.otpInputScreen);
    otp.toString().show(tag: 'otp => ');
    AppNav.goRouter.push(RtNm.userInfoInputScreen);
  }
}
