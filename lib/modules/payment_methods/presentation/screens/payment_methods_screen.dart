import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../more/presentation/widgets/menu_section.dart';
import '../../../rewards/presentation/screens/rewards_strings.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
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
              const VerticalSpace(24),
              Text(
                paymentMethods,
                style: s18W600(context),
              ),
              const VerticalSpace(AppValues.paddingLarge),
              MenuItem(
                icon: 'assets/icons/wallet.svg',
                title: savedBankCards,
                subtitle: 'See and manage cards you’ve got saved on your account',
                onTap: () {
                  AppNav.goRouter.push(RtNm.savedCardsScreen);
                },
              ),
              MenuItem(
                icon: 'assets/icons/link.svg',
                title: connectedBankAccounts,
                subtitle: 'See and manage bank accounts you’ve got connected to your account',
                onTap: () {

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
