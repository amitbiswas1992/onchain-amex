import 'package:flutter/material.dart';

import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';

class PaymentSuccessExtra {
  final double amount;
  final String paymentTo;
  final String currency;
  final VoidCallback onButtonTap;

  PaymentSuccessExtra({
    required this.amount,
    required this.paymentTo,
    required this.currency,
    required this.onButtonTap,
  });

  factory PaymentSuccessExtra.dummay() {
    return PaymentSuccessExtra(
      amount: 5.23,
      paymentTo: 'Starbucks',
      currency: 'USDC',
      onButtonTap: () {
        AppNav.goRouter.go(RtNm.spendScreen);
      },
    );
  }
}
