import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/functions.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late final SplashController _controller;

  @override
  void initState() {
    _controller = SplashController(context: context, ref: ref);
    _controller.routeNext();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLightTheme(context)
          ? AppColors.softGreen
          : AppColors.backgroundDark,
      body: Center(
        child: Image.asset(
          isLightTheme(context)
              ? 'assets/app_icons/text-logo-black.png'
              : 'assets/app_icons/text-logo-white.png',
          width: 150,
        ),
      ),
    );
  }
}
