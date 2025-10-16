import 'package:flutter/material.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/widgets/image_title_subtitle_button.dart';
import '../../../../core/widgets/texts/transaction_hash_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../data/models/payment_success_extra.dart';
import '../resources/spends_strings.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final PaymentSuccessExtra? extra;

  const PaymentSuccessScreen({super.key, required this.extra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const PrimaryAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMedium,
        ),
        child: ImageTitleSubtitleButton(
          assetPath: 'assets/icons/success.svg',
          title: paymentSuccessful,
          otherWidget: TransactionHashText(text: extra?.transactionHash ?? ''),
          subTitle:
              'Amount of ${extra?.amount.toStringAsFixed(2) ?? '0.0'} ${extra?.currency ?? ''} has been paid to ‘’${extra?.paymentTo ?? ''}’’.',
          buttonTitle: returnHome,
          onButtonTap: extra?.onButtonTap ??
              () {
                AppNav.goRouter.pop();

              },
        ),
      ),
    );
  }
}
