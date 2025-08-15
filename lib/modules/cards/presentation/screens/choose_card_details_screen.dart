import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/containers/app_chip.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../more/presentation/widgets/menu_section.dart';
import '../../data/models/choose_card_extra.dart';
import '../resources/cards_strings.dart';

class ChooseCardDetailsScreen extends ConsumerStatefulWidget {
  final ChooseCardExtra extra;

  const ChooseCardDetailsScreen({
    super.key,
    required this.extra,
  });

  @override
  ConsumerState createState() => _ChooseCardDetailsScreenState();
}

class _ChooseCardDetailsScreenState extends ConsumerState<ChooseCardDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: Column(
        children: [
          SvgPicture.asset(widget.extra.assetPath),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppValues.paddingMedium),
              child: Column(
                children: [
                  const VerticalSpace(24),
                  TitleText(text: widget.extra.title),
                  const VerticalSpace(AppValues.paddingMedium),
                  AppChip(text: widget.extra.price),
                  const VerticalSpace(32),
                  MenuItem(
                    icon: 'assets/icons/shield.svg',
                    title: alwaysASafeWayToPay,
                    subtitle: replaceDeleteOrChangeYourCardInformationAnytimeYouFeelWorried,
                    showTrailingIcon: false,
                    onTap: () {},
                  ),
                  MenuItem(
                    icon: 'assets/icons/global.svg',
                    title: worldWideUsage,
                    subtitle: useYourCardAnywhereInTheWorld,
                    showTrailingIcon: false,
                    onTap: () {},
                  ),
                  const Spacer(),
                  const Text(
                    getYourCardInstantly,
                    style: TextStyle(fontSize: 9),
                  ),
                  const VerticalSpace(AppValues.paddingSmall + 4),
                  AppPrimaryButton(
                    title: orderYourCard,
                    onTap: () {
                      AppNav.goRouter.push(RtNm.chooseCardInfoInputScreen);
                    },
                  ),
                  const VerticalSpace(AppValues.paddingLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
