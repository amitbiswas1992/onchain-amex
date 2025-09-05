import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final onboarded = await ref.read(securedStorageService).isOnboarded();

    if (onboarded) {
      AppNav.goRouter.go(RtNm.signInWithEmailScreen);
    } else {
      AppNav.goRouter.go(RtNm.onboardingScreen);
    }
  }
}
