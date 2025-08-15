import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../resources/cards_strings.dart';
import '../widgets/choose_card_tile.dart';

class ChooseCardScreen extends ConsumerStatefulWidget {
  const ChooseCardScreen({super.key});

  @override
  ConsumerState createState() => _ChooseCardScreenState();
}

class _ChooseCardScreenState extends ConsumerState<ChooseCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.paddingMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpace(AppValues.paddingLarge),
              const TitleText(text: chooseYourCard),
              const VerticalSpace(AppValues.paddingMedium),
              ChooseCardTile(
                title: starter,
                subTitle: aCardThatLiveOnline,
                assetPath: 'assets/images/starter_card.svg',
                price: '5 USD',
                onTap: () {},
              ),
              const VerticalSpace(AppValues.paddingMedium),
              ChooseCardTile(
                title: classic,
                subTitle: aCardThatCanDoMostOfYourWork,
                assetPath: 'assets/images/classic_card.svg',
                price: '10 USD',
                onTap: () {},
              ),
              const VerticalSpace(AppValues.paddingMedium),
              ChooseCardTile(
                title: elite,
                subTitle: aCardThatCanDoEveryThing,
                assetPath: 'assets/images/elite_card.svg',
                price: '20 USD',
                onTap: () {},
              ),
              const VerticalSpace(32),
            ],
          ),
        ),
      ),
    );
  }
}
