import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/resources/app_values.dart';
import '../../../../../core/utils/decimal_converter.dart';
import '../../../../../core/utils/sizebox_util.dart';
import '../../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../../core/widgets/texts/text_styles.dart';
import '../../../../../infrastructure/navigation/app_nav.dart';
import '../../../../../infrastructure/navigation/rt_nm.dart';
import '../../../borrower/more/presentation/providers/more_providers.dart';
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
  bool _isProcessing = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleWithdraw() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      _showError('Please enter an amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    final balance = ref.read(merchantProfileProvider).valueOrNull;
    double? availableBalance;
    switch (balance) {
      case Ok<MerchantProfile?>():
        availableBalance = double.tryParse(balance.data!.balance);
      case Error<MerchantProfile?>():
      case null:
    }
    if (availableBalance == null || amount > availableBalance) {
      _showError('Insufficient balance');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final withdrawRepo = ref.read(withdrawRepoProvider);

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

      final txHash = await withdrawRepo.withdrawAmount(amount);

      if (!mounted) return;

      // Wait for blockchain confirmation
      _showLoadingMessage('Waiting for blockchain confirmation...');
      await Future.delayed(const Duration(seconds: 5));

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
      if (!mounted) return;
      _showError('Transaction failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showLoadingMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.primaryLight,
        duration: const Duration(seconds: 5),
      ),
    );
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
                        'Total Value:',
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
                            '${DecimalConverter.formatAmount(balance ?? 0)} USDC',
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
                title: _isProcessing ? 'Processing...' : 'Confirm Withdrawal',
                isExpanded: true,
                onTap: _isProcessing ? null : _handleWithdraw,
              ),
            ),
            const VerticalSpace(10),
          ],
        ),
      ),
    );
  }
}
