import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_values.dart';
import '../../utils/sizebox_util.dart';
import '../texts/text_styles.dart';

class WhenLoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;

  const WhenLoadingWidget({
    super.key,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitFadingCircle(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: color ?? AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(100),
                ),
              );
            },
          ),
          if (message != null) const VerticalSpace(AppValues.paddingMedium),
          if (message != null)
            Text(
              message!,
              style: sfPro14W500.copyWith(
                color: color ?? AppColors.primaryLight,
              ),
            ),
        ],
      ),
    );
  }
}
