import '../controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import '../../../../core/resources/app_colors.dart';
import '../widgets/splash_widget.dart';

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
    return const Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SplashWidget(),
    );
  }
}
