import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/decimal_converter.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../controllers/blockchain_controller.dart';
import '../../controllers/debouce_query_controller.dart';
import '../widgets/withdraw_amount_input_widget.dart';
import '../widgets/withdraw_header_widget.dart';

class WithdrawAmountScreen extends ConsumerStatefulWidget {
  const WithdrawAmountScreen({super.key});

  @override
  ConsumerState<WithdrawAmountScreen> createState() =>
      _WithdrawAmountScreenState();
}

class _WithdrawAmountScreenState extends ConsumerState<WithdrawAmountScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // Future<void> _previewWithdraw() async {
  //   final amountText = _amountController.text.trim();
  //   if (amountText.isEmpty || amountText == '0.0') {
  //     setState(() {
  //       _sharesToBurn = null;
  //     });
  //     return;
  //   }

  //   final amount = double.tryParse(amountText);
  //   if (amount == null || amount <= 0) {
  //     setState(() {
  //       _sharesToBurn = null;
  //     });
  //     return;
  //   }

  //   try {
  //     final blockchainService = ref.read(blockchainServiceProvider);
  //     final shares = await blockchainService.previewWithdrawShares(amount);

  //     if (mounted) {
  //       setState(() {
  //         _sharesToBurn = shares;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error previewing withdraw: $e');
  //     setState(() {
  //       _sharesToBurn = null;
  //     });
  //   }
  // }

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

    setState(() {
      _isProcessing = true;
    });

    try {
      final blockchainService = ref.read(blockchainServiceProvider);

      // Check max withdrawable amount
      final maxWithdrawable =
          await blockchainService.getMaxWithdrawableAmount();
      if (amount > maxWithdrawable) {
        showErrorDialog(
          context: context,
          message:
              'Amount exceeds max withdrawable: ${DecimalConverter.formatAmount(maxWithdrawable)} USDC',
        );

        setState(() {
          _isProcessing = false;
        });
        return;
      }

      final txHash = await blockchainService.withdrawAmount(amount);

      if (!mounted) return;

      // Wait for blockchain confirmation
      showLoadingDialog(
        context: context,
        message: "Completing your transaction...",
      );
      await Future.delayed(const Duration(seconds: 7));
      hideDialog();
      // Refresh balances
      ref.invalidate(usdcBalanceProvider);
      ref.invalidate(vaultBalanceProvider);

      ref.invalidate(yieldEarnedProvider);
      ref.invalidate(maxWithdrawableAmountProvider);
      ref.invalidate(userATokenBalanceProvider);
      ref.invalidate(userYieldProvider);

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
      showErrorDialog(context: context, message: e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _setMaxAmount() async {
    try {
      final blockchainService = ref.read(blockchainServiceProvider);
      final maxWithdrawable =
          await blockchainService.getMaxWithdrawableAmount();

      if (mounted) {
        _amountController.text = maxWithdrawable.toStringAsFixed(2);
        ref
            .read(debouceQueryControllerProvider.notifier)
            .setAmount(maxWithdrawable);
      }
    } catch (e) {
      print('Error getting max withdrawable: $e');
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

  @override
  Widget build(BuildContext context) {
    final userATokenBalance = ref.watch(userATokenBalanceProvider);
    final userYield = ref.watch(userYieldProvider);
    final maxWithdrawable = ref.watch(maxWithdrawableAmountProvider);
    final previewWithdraw = ref.watch(previewWithdrawProvider);

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
            const WithdrawHeaderWidget(),
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
                      userATokenBalance.when(
                        data: (balance) => Text(
                          '${DecimalConverter.formatAmount(balance)} USDC',
                          style: const TextStyle(
                            color: AppColors.c212121,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                  const VerticalSpace(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Earned Yield:',
                        style: TextStyle(
                          color: AppColors.c757575,
                          fontSize: 14,
                        ),
                      ),
                      userYield.when(
                        data: (yieldAmount) => Text(
                          '${DecimalConverter.formatAmount(yieldAmount)} USDC',
                          style: const TextStyle(
                            color: AppColors.jungleGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        loading: () => const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (_, __) => const Text('Error'),
                      ),
                    ],
                  ),
                  const VerticalSpace(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Max Withdrawable:',
                        style: TextStyle(
                          color: AppColors.c757575,
                          fontSize: 14,
                        ),
                      ),
                      maxWithdrawable.when(
                        data: (maxAmount) => Row(
                          children: [
                            Text(
                              '${DecimalConverter.formatAmount(maxAmount)} USDC',
                              style: const TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: _setMaxAmount,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'MAX',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        loading: () => const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (_, __) => const Text('Error'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const VerticalSpace(20),
            WithdrawAmountInputWidget(
              controller: _amountController,
              onChanged: (value) => ref
                  .read(debouceQueryControllerProvider.notifier)
                  .setAmount(double.tryParse(value) ?? 0.0),
            ),

            // Preview shares to burn
            if (previewWithdraw.valueOrNull != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'This will burn  ',
                    style: TextStyle(color: AppColors.c757575, fontSize: 14),
                  ),
                  previewWithdraw.when(
                    data: (shares) => shares == null
                        ? const Text('--')
                        : Text(
                            DecimalConverter.formatAmount(shares),
                            style: const TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    loading: () => const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, __) => const Text(
                      '0.00',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                  const Text(
                    '  of your vault shares',
                    style: TextStyle(color: AppColors.c757575, fontSize: 14),
                  ),
                ],
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
