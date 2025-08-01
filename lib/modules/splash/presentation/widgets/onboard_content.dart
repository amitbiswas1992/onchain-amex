import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class OnboardContent extends StatelessWidget {
  final String assetPath;
  final String title;
  final String description;

  const OnboardContent({
    super.key,
    required this.assetPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: SvgPicture.asset(
            assetPath,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const VerticalSpace(32),
            Text(
              title,
              style: s28W600(context),
              textAlign: TextAlign.center,
            ),
            const VerticalSpace(AppValues.paddingSmall),
            Text(
              description,
              textAlign: TextAlign.center,
              style: s14W400(context),
            ),
          ],
        ),
      ],
    );
  }
}
