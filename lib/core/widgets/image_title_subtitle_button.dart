import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../resources/app_values.dart';
import '../utils/sizebox_util.dart';
import 'buttons/app_primary_button.dart';
import 'texts/text_styles.dart';
import 'texts/title_text.dart';

class ImageTitleSubtitleButton extends StatelessWidget {
  final String assetPath;
  final String title;
  final String subTitle;
  final String buttonTitle;
  final Widget? otherWidget;
  final VoidCallback onButtonTap;

  const ImageTitleSubtitleButton({
    super.key,
    required this.assetPath,
    required this.title,
    required this.subTitle,
    required this.buttonTitle,
    required this.onButtonTap, this.otherWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        assetPath.contains('.svg') ? SvgPicture.asset(assetPath) :
        Image.asset(
          assetPath,
        ),
        const SizedBox(height: AppValues.paddingLarge),
        TitleText(
          text: title,
          textAlign: TextAlign.center,
        ),
        const VerticalSpace(AppValues.paddingMedium),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style: s14W400(context),
        ),
        if (otherWidget != null)
          const VerticalSpace(AppValues.paddingMedium + AppValues.paddingMedium),
        if (otherWidget != null)
          otherWidget!,
        const VerticalSpace(32),
        AppPrimaryButton(
          title: buttonTitle,
          onTap: onButtonTap,
        ),
      ],
    );
  }
}
