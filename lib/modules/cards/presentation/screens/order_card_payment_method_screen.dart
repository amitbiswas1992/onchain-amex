import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../more/presentation/widgets/menu_section.dart';
import '../resources/cards_strings.dart';

class OrderCardPaymentMethodScreen extends ConsumerStatefulWidget {
  const OrderCardPaymentMethodScreen({super.key});

  @override
  ConsumerState createState() => _OrderCardPaymentMethodScreenState();
}

class _OrderCardPaymentMethodScreenState extends ConsumerState<OrderCardPaymentMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppValues.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                choosePaymentMethod,
                style: s18W600(context),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              MenuItem(
                icon: 'assets/icons/visa.svg',
                title: debitCard,
                onTap: () {
                  ref.read(bottomNavSelectedIndexProvider.notifier).state = 1;
                  AppNav.goRouter.go(RtNm.cardsScreen);
                },
                doNotUseIconColor: true,
              ),
              MenuItem(
                icon: 'assets/icons/mastercard.svg',
                title: creditCard,
                onTap: () {
                  ref.read(bottomNavSelectedIndexProvider.notifier).state = 1;
                  AppNav.goRouter.go(RtNm.cardsScreen);
                },
                doNotUseIconColor: true,
              ),
              MenuItem(
                icon: 'assets/icons/bank.svg',
                title: usCentralBank,
                onTap: () {
                  ref.read(bottomNavSelectedIndexProvider.notifier).state = 1;
                  AppNav.goRouter.go(RtNm.cardsScreen);
                },
              ),
              MenuItem(
                icon: 'assets/icons/bank.svg',
                title: bracBankLtd,
                onTap: () {
                  ref.read(bottomNavSelectedIndexProvider.notifier).state = 1;
                  AppNav.goRouter.go(RtNm.cardsScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
