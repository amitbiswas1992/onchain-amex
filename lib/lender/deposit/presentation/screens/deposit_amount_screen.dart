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
import '../widgets/deposit_amount_input_widget.dart';
import '../widgets/deposit_header_widget.dart';

class DepositAmountScreen extends ConsumerStatefulWidget {
  const DepositAmountScreen({super.key});

  @override
  ConsumerState<DepositAmountScreen> createState() =>
      _DepositAmountScreenState();
}

class _DepositAmountScreenState extends ConsumerState<DepositAmountScreen>
    with WidgetsBindingObserver {
  final TextEditingController _amountController = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh data when app comes back to foreground or screen is visible
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _handleDeposit() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      showErrorDialog(context: context, message: 'Please enter an amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      showErrorDialog(context: context, message: 'Please enter a valid amount');

      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final blockchainService = ref.read(blockchainServiceProvider);

      // Check USDC balance
      final balance = await blockchainService.getUsdcBalance();
      if (balance < amount) {
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      // Check allowance
      final allowance = await blockchainService.getUsdcAllowance();
      print('Current allowance: $allowance, required: $amount');
      if (allowance < amount) {
        await blockchainService.approveUsdc(amount);
        showLoadingDialog(context: context, message: 'Waiting for approval...');
        await Future.delayed(const Duration(seconds: 2));
        hideDialog();
      }
      final depositTxHash = await blockchainService.deposit(amount);

      if (!mounted) return;

      showLoadingDialog(
        context: context,
        message: "Completing your transaction...",
      );
      await Future.delayed(const Duration(seconds: 5));
      hideDialog();

      // Refresh balances after waiting
      ref.invalidate(usdcBalanceProvider);
      ref.invalidate(userATokenBalanceProvider);
      ref.invalidate(vaultBalanceProvider);

      ref.invalidate(yieldEarnedProvider);

      // Navigate to confirmation
      AppNav.goRouter.push(
        RtNm.successScreen,
        extra: {
          'title': 'Deposit Successful',
          'subtitle':
              'You have successfully deposited ${DecimalConverter.formatAmount(amount)} USDC to your vault.',
          'txHash': depositTxHash,
        },
      );
    } catch (e) {
      print('Deposit error: $e');
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

  @override
  Widget build(BuildContext context) {
    final usdcBalance = ref.watch(usdcBalanceProvider);
    final previewDeposit = ref.watch(previewDepositProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => AppNav.goRouter.pop(),
        ),
        title: Text('Deposit', style: s18W600(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppValues.paddingMedium),
        child: Column(
          children: [
            const DepositHeaderWidget(),
            const VerticalSpace(20),
            // Show USDC balance
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available USDC Balance:',
                    style: TextStyle(color: AppColors.c757575, fontSize: 14),
                  ),
                  usdcBalance.when(
                    data: (balance) => Text(
                      DecimalConverter.formatAmount(balance),
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
                      '0.00',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalSpace(10),
            DepositAmountInputWidget(controller: _amountController),
            const VerticalSpace(10),
            previewDeposit.valueOrNull == null
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('You will receive approximately'),
                      const HorizontalSpace(8),
                      previewDeposit.when(
                        data: (shares) => Text(
                          shares == null
                              ? ' --'
                              : DecimalConverter.formatAmount(shares),
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
                          ' 0.00',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Text('  vault shares'),
                    ],
                  ),
            const Spacer(),
            SafeArea(
              child: AppPrimaryButton(
                title: _isProcessing ? 'Processing...' : 'Confirm Deposit',
                isExpanded: true,
                onTap: _isProcessing ? null : _handleDeposit,
              ),
            ),
            const VerticalSpace(10),
          ],
        ),
      ),
    );
  }
}
