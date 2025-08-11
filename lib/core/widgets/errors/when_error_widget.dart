import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/app_values.dart';
import '../../utils/sizebox_util.dart';

class WhenErrorWidget extends StatelessWidget {
  final Object? error;
  final String? message;
  final Color? color;

  const WhenErrorWidget({
    super.key,
    this.error,
    this.message, this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsGeometry.all(
          AppValues.paddingLarge,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/error_circle.svg'),
            const VerticalSpace(AppValues.paddingMedium),
            Text(
              error?.toString() ?? message ?? 'Something went wrong.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
