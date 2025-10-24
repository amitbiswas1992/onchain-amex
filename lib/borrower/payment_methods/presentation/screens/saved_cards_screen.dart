import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../cards/presentation/providers/card_providers.dart';
import '../../../cards/presentation/resources/cards_strings.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../more/presentation/widgets/menu_section.dart';
import '../../../rewards/presentation/screens/rewards_strings.dart';
import '../providers/payment_method_providers.dart';
import '../widgets/saved_cards_empty_widget.dart';

class SavedCardsScreen extends ConsumerStatefulWidget {
  const SavedCardsScreen({super.key});

  @override
  ConsumerState createState() => _SavedCardsScreenState();
}

class _SavedCardsScreenState extends ConsumerState<SavedCardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMedium,
        ),
        child: Column(
          children: [
            Expanded(
              child: Consumer(builder: (context, ref, _) {
                final cardSaved = ref.watch(cardSavedProvider);

                if (cardSaved == false) {
                  return const SavedCardsEmptyWidget();
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalSpace(AppValues.paddingLarge),
                      Text(
                        savedBankCards,
                        style: s18W600(context),
                      ),
                      const VerticalSpace(AppValues.paddingMedium),
                      MenuItem(
                        icon: 'assets/icons/visa.svg',
                        title: debitCard,
                        subtitle: '************1234',
                        onTap: () {
                          ref.read(bottomNavSelectedIndexProvider.notifier).state = 1;
                          ref.read(cardAddedProvider.notifier).state = true;
                          AppNav.goRouter.go(RtNm.cardsScreen);
                        },
                        doNotUseIconColor: true,
                      ),
                      MenuItem(
                        icon: 'assets/icons/mastercard.svg',
                        title: creditCard,
                        subtitle: '************1234',
                        onTap: () {
                          ref.read(bottomNavSelectedIndexProvider.notifier).state = 1;
                          ref.read(cardAddedProvider.notifier).state = true;
                          AppNav.goRouter.go(RtNm.cardsScreen);
                        },
                        doNotUseIconColor: true,
                      ),
                    ],
                  ),
                );
              },),
            ),
            SafeArea(
              child: AppPrimaryButton(
                title: addCard,
                onTap: () {
                  AppNav.goRouter.push(RtNm.addACardScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
