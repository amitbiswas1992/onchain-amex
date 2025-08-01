import '../../../../core/widgets/texts/text_styles.dart';
import '../controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import '../../../../core/resources/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashController _controller;

  @override
  void initState() {
    _controller = SplashController(context: context);
    _controller.routeNext();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGreen,
      body: Center(
        child: Text(
          'Amex',
          style: s32W600(context).copyWith(
            color: AppColors.primaryLight,
            fontSize: 56,
          ),
        ),
      ),
    );
  }
}
