import 'package:flutter/material.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/containers/light_card.dart';
import '../../../../core/widgets/texts/large_number_text.dart';
import '../resources/home_strings.dart';

class HomeAvailableToSpend extends StatelessWidget {
  const HomeAvailableToSpend({super.key});

  @override
  Widget build(BuildContext context) {
    return LightCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingMedium,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(availableToSPend),
          const VerticalSpace(AppValues.paddingSmall),
          const LargeNumberText(text: '475.65', fontSize: 34),
          const VerticalSpace(AppValues.paddingMedium),
          Row(
            children: [
              Expanded(
                child: AppSecondaryButton(
                  title: add,
                  showBorder: false,
                  deepColor: true,
                  rounded: true,
                  onTap: () {},
                ),
              ),
              const HorizontalSpace(AppValues.paddingMedium),
              Expanded(
                child: AppSecondaryButton(
                  title: repay,
                  showBorder: false,
                  deepColor: true,
                  rounded: true,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
