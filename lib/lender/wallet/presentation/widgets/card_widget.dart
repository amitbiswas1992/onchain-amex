import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/green_rounded_icon_button.dart';
import '../../../../core/widgets/containers/deem_card.dart';
import '../resources/cards_strings.dart';
import 'card_info_tile.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GreenRoundedIconButton(
                            title: showPin,
                            assetPath: 'assets/icons/show_pin.svg',
                            onTap: () {},
                          ),
                          GreenRoundedIconButton(
                            title: freezeCard,
                            assetPath: 'assets/icons/snowflake.svg',
                            onTap: () {},
                          ),
                          GreenRoundedIconButton(
                            title: more,
                            assetPath: 'assets/icons/more_vert.svg',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const VerticalSpace(AppValues.paddingMedium),
                      const DeemCard(
                        padding: EdgeInsets.all(AppValues.paddingMedium),
                        child: Column(
                          children: [
                            CardInfoTile(title: 'Name', value: 'SHAKIR AHMED'),
                            CardInfoTile(
                              title: 'Card number',
                              value: '2345 6543 4567 1234',
                            ),
                            CardInfoTile(title: 'CVC', value: '616'),
                            CardInfoTile(title: 'Expire Date', value: '05/32'),
                            CardInfoTile(
                              title: 'Billing address',
                              value:
                                  'Road 02, Block C, Mirpur DOHS, Dhaka, 1221.',
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpace(24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
