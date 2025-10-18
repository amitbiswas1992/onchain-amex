import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../home/presentation/providers/home_providers.dart';

class PaymentSuccessExtra {
  final double amount;
  final String paymentTo;
  final String currency;
  final String? transactionHash;
  final VoidCallback onButtonTap;

  PaymentSuccessExtra({
    required this.amount,
    required this.paymentTo,
    required this.currency,
    this.transactionHash,
    required this.onButtonTap,
  });

  factory PaymentSuccessExtra.dummay({WidgetRef? ref}) {
    return PaymentSuccessExtra(
      amount: 5.23,
      paymentTo: 'Starbucks',
      currency: 'USDC',
      onButtonTap: () {
        ref?.invalidate(bottomNavSelectedIndexProvider);
        AppNav.goRouter.go(RtNm.spendScreen);
      },
    );
  }
}
