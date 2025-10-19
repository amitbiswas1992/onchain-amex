import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../rewards/presentation/screens/rewards_strings.dart';

class SavedCardsEmptyWidget extends StatelessWidget {
  final String? assetPath;
  final String? title;
  final String? subTitle;

  const SavedCardsEmptyWidget({
    super.key,
    this.assetPath,
    this.title,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          assetPath ?? 'assets/images/chromed_mone_savings.png',
          width: 273,
          height: 280,
        ),
        const VerticalSpace(AppValues.paddingMedium),
        TitleText(text: title ?? addABankCard),
        const VerticalSpace(AppValues.paddingMedium),
        Text(
          subTitle ?? 'Tap on the button to add a bank card to your account. You can use this for repayments.',
          style: s14W400(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
