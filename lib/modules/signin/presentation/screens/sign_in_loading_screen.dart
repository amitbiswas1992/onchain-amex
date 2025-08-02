import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../widgets/amex_text_app_bar.dart';

class SignInLoadingScreen extends StatelessWidget {
  const SignInLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          AmexTextAppBar(),
          // VerticalSpace(68),
          Expanded(
            child: Center(
              child: SpinKitFadingCube(
                color: AppColors.primaryVariantLight,
                size: 24,
                duration: const Duration(milliseconds: 300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
