import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/texts/transaction_hash_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../wallet/business/services/wallet_service.dart';
import '../../../wallet/business/services/wallet_service_interface.dart';
import 'dart:developer' as dev;

class AddAndRepayController {
  final BuildContext context;
  final WidgetRef ref;
  final WalletService walletService;

  const AddAndRepayController({required this.context, required this.ref, required this.walletService});

  Future<void> repay(String input) async {
    final amount = double.tryParse(input);
    if (amount == null) {
      showWarningDialog(context: context, message: 'Invalid amount');
      return;
    }
    if (amount <= 0) {
      showWarningDialog(context: context, message: 'Amount must be greater than 0');
      return;
    }

    try {
      showLoadingDialog(context: context, message: 'Checking allowance...');
      final allowance = await walletService.getUsdcAllowance();
      hideDialog();
      dev.log('Allowance: $allowance');
      if (allowance < amount) {
        // Need to approve first
        final shouldApprove = await showPermissionDialog(context: context, message: 'Are you sure you want to repay amount: ${amount.toStringAsFixed(2)}?');
        if (!shouldApprove) {
          return;
        }
        await walletService.approveUsdc(amount);
        showLoadingDialog(context: context, message: 'Waiting for approval...');
        await Future.delayed(const Duration(seconds: 2));
        hideDialog();
      }

      final txHash = await walletService.repay(amount);

      showSuccessDialog(
        context: context,
        message: 'Wallet connected successfully.',
        otherWidget:
        TransactionHashText(text: txHash),
        onDone: () {
          AppNav.goRouter.go(RtNm.homeScreen);
        },
      );
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      showErrorDialog(context: context, message: error.toString());
    }

  }

  Future<void> mintUsdc(double amount) async {
    try {
      await walletService.mintUsdc(amount);
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
  }

}
