import 'package:flutter/material.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../resources/signin_strings.dart';

class AmexTextAppBar extends StatelessWidget {
  const AmexTextAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Column(
      children: [
        VerticalSpace(padding.top + AppValues.paddingLarge + AppValues.paddingMedium),
        Center(
          child: Text(
            SignInStrings.amex,
            textAlign: TextAlign.center,
            style: s32W600(context).copyWith(color: AppColors.primaryVariantLight),
          ),
        ),
      ],
    );
  }
}
