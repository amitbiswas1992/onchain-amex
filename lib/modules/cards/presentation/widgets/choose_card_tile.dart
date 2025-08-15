import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/containers/app_chip.dart';
import '../../../../core/widgets/containers/deem_card.dart';
import '../resources/cards_strings.dart';

class ChooseCardTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String assetPath;
  final String price;
  final Function() onTap;

  const ChooseCardTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.assetPath,
    required this.onTap,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DeemCard(
        padding: const EdgeInsets.all(
          AppValues.paddingMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w600,
              ),
            ),
            const VerticalSpace(AppValues.paddingMedium),
            Text(subTitle),
            const VerticalSpace(AppValues.paddingMedium),
            AppChip(text: price),
            const VerticalSpace(AppValues.paddingMedium),
            SvgPicture.asset(assetPath),
          ],
        ),
      ),
    );
  }
}
