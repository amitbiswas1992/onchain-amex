import 'package:flutter/material.dart';

import '../../modules/invite_friend/presentation/resources/invite_strings.dart';
import '../../modules/signin/presentation/resources/signin_strings.dart';
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
  final VoidCallback onButtonTap;

  const ImageTitleSubtitleButton({
    super.key,
    required this.assetPath,
    required this.title,
    required this.subTitle,
    required this.buttonTitle,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          assetPath,
        ),
        const SizedBox(height: AppValues.paddingSmall),
        TitleText(
          text: title,
        ),
        const VerticalSpace(AppValues.paddingMedium),
        Text(
          subTitle,
          style: s14W400(context),
        ),
        const VerticalSpace(32),
        AppPrimaryButton(
          title: buttonTitle,
          onTap: onButtonTap,
        ),
      ],
    );
  }
}
