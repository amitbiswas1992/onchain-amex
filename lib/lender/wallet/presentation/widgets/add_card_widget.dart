import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../borrower/more/presentation/widgets/menu_section.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../resources/cards_strings.dart';

class AddCardWidget extends StatelessWidget {
  const AddCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        VerticalSpace(padding.top),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const VerticalSpace(AppValues.paddingMedium),
                SvgPicture.asset('assets/images/starter_card.svg'),
                const VerticalSpace(24),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.paddingMedium,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        letsGetACard,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 27,
                        ),
                      ),
                      const VerticalSpace(24),
                      MenuItem(
                        icon: 'assets/icons/bottom_nav/wallet.svg',
                        title: instantAccess,
                        subtitle: applyAndGetYourVirtualCard,
                        onTap: () {},
                        showTrailingIcon: false,
                      ),
                      MenuItem(
                        icon: 'assets/icons/global.svg',
                        title: worldWideUsage,
                        subtitle: useYourCardAnywhereInTheWorld,
                        onTap: () {},
                        showTrailingIcon: false,
                      ),
                      MenuItem(
                        icon: 'assets/icons/gift_dark.svg',
                        title: exitingOfferEveryday,
                        subtitle: byUsingYourCardEveryDay,
                        onTap: () {},
                        showTrailingIcon: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.paddingMedium,
            vertical: AppValues.paddingMedium,
          ),
          child: AppPrimaryButton(
            title: getYourFirstCard,
            onTap: () {
              AppNav.goRouter.push(RtNm.chooseCardScreen);
            },
          ),
        ),
      ],
    );
  }
}
