import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/containers/light_card.dart';
import '../../../../core/widgets/texts/large_number_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../more/data/models/profile.dart';
import '../resources/home_strings.dart';

class HomeAvailableToSpend extends StatelessWidget {
  final num availableCreditAmount;
  final Profile? profile;

  const HomeAvailableToSpend({
    super.key,
    required this.availableCreditAmount,
    required this.profile,
  });

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
          LargeNumberText(
            text: availableCreditAmount <= 0
                ? availableCreditAmount.toString()
                : (availableCreditAmount / oneMillion).toStringAsFixed(2),
            fontSize: 34,
          ),
          const VerticalSpace(AppValues.paddingMedium),
          Row(
            children: [
              // Expanded(
              //   child: AppSecondaryButton(
              //     title: add,
              //     showBorder: false,
              //     deepColor: true,
              //     rounded: true,
              //     onTap: () {
              //       AppNav.goRouter.push(RtNm.addFoundScreen);
              //     },
              //   ),
              // ),
              // const HorizontalSpace(AppValues.paddingMedium),
              Expanded(
                child: AppSecondaryButton(
                  title: repay,
                  showBorder: false,
                  deepColor: true,
                  rounded: true,
                  onTap: () {
                    if (profile != null) {
                      AppNav.goRouter.push(RtNm.replayFoundScreen, extra: profile);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
