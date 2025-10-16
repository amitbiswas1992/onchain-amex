import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/texts/transaction_hash_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../more/presentation/providers/more_providers.dart';
import '../../../wallet/business/services/wallet_service.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import '../../data/models/payment_success_extra.dart';
import '../../data/models/scanned_data.dart';

class PaymentController {
  final BuildContext context;
  final WidgetRef ref;
  final WalletService walletService;

  const PaymentController({
    required this.context,
    required this.ref,
    required this.walletService,
  });

  Future<void> doPayment({
    required num availableCredit,
    required ScannedData scannedData,
    required String amountStr,
  }) async {
    AppNav.goRouter.pushReplacement(
      RtNm.paymentSuccessScreen,
      extra: PaymentSuccessExtra(
        amount: 100,
        transactionHash: '0x23jshdh73456sadhbf7r3463uhf74756',
        paymentTo: scannedData.merchantName ?? 'Unknown Merchant',
        currency: 'USDC',
        onButtonTap: () {
          AppNav.goRouter.go(RtNm.homeScreen);
          ref.invalidate(bottomNavSelectedIndexProvider);
          ref.invalidate(profileProvider);
          ref.invalidate(availableCreditProvider);
          ref.invalidate(borrowerProfileProvider);
        },
      ),
    );
    return;

    final amount = double.tryParse(amountStr) ?? 0.0;

    if (amount <= 0) {
      showWarningDialog(context: context, message: 'Amount must be greater than 0');
      return;
    }

    if (amount > availableCredit) {
      showWarningDialog(
          context: context, message: 'Amount must be less than or equal to available credit');
      return;
    }

    try {
      await walletService.approveUsdc(amount);
      showLoadingDialog(context: context, message: 'Waiting for approval...');
      await Future.delayed(const Duration(seconds: 2));
      hideDialog();

      final txHash = await walletService.spend(
          amount: amount, merchantPublicAddress: scannedData.walletAddress!);

      showLoadingDialog(context: context, message: "Completing your transaction...");
      await Future.delayed(const Duration(seconds: 2));
      hideDialog();

      AppNav.goRouter.pushReplacement(
        RtNm.paymentSuccessScreen,
        extra: PaymentSuccessExtra(
          amount: amount,
          transactionHash: txHash,
          paymentTo: scannedData.merchantName ?? 'Unknown Merchant',
          currency: 'USDC',
          onButtonTap: () {
            AppNav.goRouter.go(RtNm.homeScreen);
            ref.invalidate(bottomNavSelectedIndexProvider);
            ref.invalidate(profileProvider);
            ref.invalidate(availableCreditProvider);
            ref.invalidate(borrowerProfileProvider);
          },
        ),
      );

      // showSuccessDialog(
      //   context: context,
      //   message: 'Repay completed successfully.',
      //   otherWidget:
      //   TransactionHashText(text: txHash),
      //   dismissible: false,
      //   onDone: () {
      //     AppNav.goRouter.go(RtNm.homeScreen);
      //     ref.invalidate(profileProvider);
      //     ref.invalidate(availableCreditProvider);
      //     ref.invalidate(borrowerProfileProvider);
      //   },
      // );
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      showErrorDialog(context: context, message: error.toString());
    }
  }
}
