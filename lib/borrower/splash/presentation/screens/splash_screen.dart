import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_strings.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import '../../../../core/resources/app_colors.dart';

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
      backgroundColor: isLightTheme(context) ? AppColors.softGreen : null,
      body: Center(
        child: Text(
          appTitle,
          style: s32W600(context).copyWith(
            color: AppColors.primaryLight,
            fontSize: 56,
          ),
        ),
      ),
    );
  }
}
