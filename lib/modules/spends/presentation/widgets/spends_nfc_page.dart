import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/animated_ring_loader.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../resources/spends_strings.dart';

class SpendsNfcPage extends StatelessWidget {
  const SpendsNfcPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingMedium,
      ),
      child: Column(
        children: [
          SvgPicture.asset('assets/icons/nfc_card.svg'),
          const VerticalSpace(AppValues.paddingMedium),
          const Text(holdYourPhoneNearThePOS),
          const VerticalSpace(AppValues.paddingLarge),
          InkWell(
            onTap: () {
              AppNav.goRouter.push(RtNm.spendAfterScanAmountInputScreen);
            },
            child: Container(
              height: size.width * .6,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppValues.borderRadiusMedium),
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFF464646), // Light color in center
                    Color(0xFF1E1E1E), // Dark color outside
                  ],
                  center: Alignment.center,
                  radius: 0.8, // Increase for wider light area
                ),
              ),
              child: AnimatedRingLoader(
                child: SvgPicture.asset('assets/icons/buzzing.svg'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
