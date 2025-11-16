import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/resources/app_values.dart';
import '../../../../../core/utils/decimal_converter.dart';
import '../../../../../core/utils/sizebox_util.dart';
import '../../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../../core/widgets/texts/text_styles.dart';
import '../../../../../infrastructure/navigation/app_nav.dart';
import '../../../../../infrastructure/navigation/rt_nm.dart';
import '../../../borrower/more/presentation/providers/more_providers.dart';
import '../../../core/widgets/dialogs.dart';
import '../../../infrastructure/network/result.dart';
import '../../../lender/deposit/controllers/blockchain_controller.dart';
import '../../../lender/deposit/presentation/widgets/withdraw_amount_input_widget.dart';
import '../model/merchant_profile.dart';
import 'withdraw_controller.dart';

class MerchantWithdrawScreen extends ConsumerStatefulWidget {
  const MerchantWithdrawScreen({super.key});

  @override
  ConsumerState<MerchantWithdrawScreen> createState() =>
      _MerchantWithdrawScreenState();
}

class _MerchantWithdrawScreenState
    extends ConsumerState<MerchantWithdrawScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleWithdraw() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      showErrorDialog(context: context, message: 'Please enter an amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      showErrorDialog(
        context: context,
        message: 'Please enter a valid amount',
      );
      return;
    }

    final balance = ref.read(merchantProfileProvider).valueOrNull;
    double? availableBalance;
    switch (balance) {
      case Ok<MerchantProfile?>():
        // availableBalance = double.tryParse(balance.data!.balance);
        availableBalance = DecimalConverter.toUiAmount(
          BigInt.from(double.tryParse(balance.data!.balance) ?? 0),
        );

      case Error<MerchantProfile?>():
      case null:
    }
    print('Available balance: $availableBalance');
    if (availableBalance == null || amount > availableBalance) {
      showErrorDialog(
        context: context,
        message: 'Insufficient balance for this withdrawal',
      );
      return;
    }

    try {
      final walletService = ref.read(withdrawServiceProvider);

      // showLoadingDialog(context: context, message: 'Checking allowance...');
      // final allowance = await walletService.getUsdcAllowance();
      // hideDialog();
      // // dev.log('Allowance: $allowance');
      // if (allowance < amount) {
      //   // Need to approve first
      //   final shouldApprove = await showPermissionDialog(
      //     context: context,
      //     message:
      //         'Are you sure you want to withdraw amount: ${amount.toStringAsFixed(2)}?',
      //   );
      //   if (!shouldApprove) {
      //     return;
      //   }
      //   await walletService.approveUsdc(amount);
      //   showLoadingDialog(context: context, message: 'Waiting for approval...');
      //   await Future.delayed(const Duration(seconds: 2));
      //   hideDialog();
      // }

      // // Check max withdrawable amount
      // final maxWithdrawable =
      //     await blockchainService.getMaxWithdrawableAmount();
      // if (amount > maxWithdrawable) {
      //   _showError(
      //     'Amount exceeds max withdrawable: ${DecimalConverter.formatAmount(maxWithdrawable)} USDC',
      //   );
      //   setState(() {
      //     _isProcessing = false;
      //   });
      //   return;
      // }

      final txHash = await walletService.withdrawAmount(amount);

      print(txHash);
      if (!mounted) return;

      // Wait for blockchain confirmation
      showLoadingDialog(
        context: context,
        message: "Completing your transaction...",
      );
      await Future.delayed(const Duration(seconds: 5));
      hideDialog();
      // Refresh balances
      ref.invalidate(merchantProfileProvider);
      // ref.invalidate(usdcBalanceProvider);

      // Navigate to success screen
      AppNav.goRouter.push(
        RtNm.successScreen,
        extra: {
          'title': 'Withdrawal Successful',
          'subtitle':
              'You have successfully withdrawn ${DecimalConverter.formatAmount(amount)} USDC by burning ${ref.read(previewWithdrawProvider).valueOrNull != null ? DecimalConverter.formatAmount(ref.read(previewWithdrawProvider).valueOrNull!) : '--'} shares from your vault.',
          'txHash': txHash,
        },
      );
    } catch (e) {
      print('Withdraw error: $e');
      if (e is JsonRpcError) {
        showErrorDialog(
          context: context,
          message: e.message ?? 'An error occurred during withdrawal',
        );
        return;
      }

      showErrorDialog(context: context, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final merchant = ref.watch(merchantProfileProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => AppNav.goRouter.pop(),
        ),
        title: Text('Withdraw', style: s18W600(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppValues.paddingMedium),
        child: Column(
          children: [
            const VerticalSpace(10),
            // Account Summary
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Balance:',
                        style: TextStyle(
                          color: AppColors.c757575,
                          fontSize: 14,
                        ),
                      ),
                      merchant.when(
                        data: (profile) {
                          double? balance;
                          switch (profile) {
                            case Ok<MerchantProfile?>():
                              balance = double.tryParse(profile.data!.balance);
                            case Error<MerchantProfile?>():
                          }
                          return Text(
                            '${DecimalConverter.toUiAmount(BigInt.from(balance ?? 0))} USDC',
                            style: const TextStyle(
                              color: AppColors.c212121,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                        loading: () => const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (_, __) => const Text(
                          'Error',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const VerticalSpace(20),
            WithdrawAmountInputWidget(
              controller: _amountController,
              onChanged: (value) {},
            ),
            const Spacer(),
            SafeArea(
              child: AppPrimaryButton(
                title: 'Confirm Withdrawal',
                isExpanded: true,
                onTap: _handleWithdraw,
              ),
            ),
            const VerticalSpace(10),
          ],
        ),
      ),
    );
  }
}
