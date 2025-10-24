import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../more/presentation/widgets/menu_section.dart';
import '../../../rewards/presentation/screens/rewards_strings.dart';
import '../providers/payment_method_providers.dart';
import '../widgets/saved_cards_empty_widget.dart';

class ConnectedBankAccountsScreen extends ConsumerStatefulWidget {
  const ConnectedBankAccountsScreen({super.key});

  @override
  ConsumerState createState() => _ConnectedBankAccountsScreenState();
}

class _ConnectedBankAccountsScreenState extends ConsumerState<ConnectedBankAccountsScreen> {
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
                log('===> $cardSaved');

                if (cardSaved == false) {
                  return const SavedCardsEmptyWidget(
                    assetPath: 'assets/images/chromed_banking.png',
                    title: addABankAccount,
                    subTitle: 'Tap on the button to add a bank account to your account. You can use this for repayments.',
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalSpace(AppValues.paddingLarge),
                      Text(
                        savedBankAccounts,
                        style: s18W600(context),
                      ),
                      const VerticalSpace(AppValues.paddingMedium),
                      MenuItem(
                        icon: 'assets/icons/bank.svg',
                        title: 'US Central Bank (ACH)',
                        subtitle: '************1234',
                        onTap: () {

                        },
                      ),
                      MenuItem(
                        icon: 'assets/icons/bank.svg',
                        title: 'BRAC Bank Ltd',
                        subtitle: '************1234',
                        onTap: () {

                        },
                      ),
                    ],
                  ),
                );
              },),
            ),
            SafeArea(
              child: AppPrimaryButton(
                title: connectBankAccount,
                onTap: () {
                  AppNav.goRouter.push(RtNm.bankLocationSelectScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

