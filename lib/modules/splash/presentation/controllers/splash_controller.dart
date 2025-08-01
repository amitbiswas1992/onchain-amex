import 'package:flutter/material.dart';

import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';

class SplashController {
  final BuildContext context;

  SplashController({required this.context});

  void routeNext() async {
    await Future.delayed(const Duration(seconds: 3));
    AppNav.goRouter.go(RtNm.onboardingScreen);

    // final userData = await getIt<SecuredStorageService>().getUserData();
    // if (userData != null) {
    //   // AppNav.goRouter.push(RtNm.homeScreen);
    // } else {
    //   // AppNav.goRouter.push(RtNm.tutorialScreen, extra: UserType.traveler);
    // }
  }

}