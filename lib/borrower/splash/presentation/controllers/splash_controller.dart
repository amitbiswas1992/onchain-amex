import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';

class SplashController {
  final BuildContext context;
  final WidgetRef ref;

  SplashController({
    required this.context,
    required this.ref,
  });

  void routeNext() async {
    await Future.delayed(const Duration(seconds: 3));
    final first = await _isFirstTime();
    if (first) {
      await ref.read(securedStorageService).deleteAll();
    }

    final userTokens = await ref.read(securedStorageService).getUserModel();
    print(userTokens);
    if (userTokens != null) {
      if (userTokens.user.userType == 'LENDER') {
        AppNav.goRouter.go(RtNm.lenderHomeScreen);
      } else if (userTokens.user.userType == 'BORROWER') {
        AppNav.goRouter.go(RtNm.homeScreen);
      } else {
        if (await ref.read(securedStorageService).getMerchantMode() ==
            'Lender') {
          AppNav.goRouter.go(RtNm.lenderHomeScreen);
          return;
        }
        AppNav.goRouter.go(RtNm.merchantHomeScreen);
      }
      return;
    }

    final onboarded = await ref.read(securedStorageService).isOnboarded();

    if (onboarded) {
      AppNav.goRouter.go(RtNm.registerWithEmailScreen);
    } else {
      AppNav.goRouter.go(RtNm.onboardingScreen);
    }
  }

  static Future<bool> _isFirstTime() async {
    final shared = await SharedPreferences.getInstance();
    final isFirstTime = shared.getBool('first_time');
    if (isFirstTime != null && !isFirstTime) {
      await shared.setBool('first_time', false);
      return false;
    } else {
      await shared.setBool('first_time', false);
      return true;
    }
  }
}
