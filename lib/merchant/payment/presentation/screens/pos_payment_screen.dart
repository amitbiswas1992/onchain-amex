import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../borrower/more/data/models/profile.dart';
import '../../../../borrower/more/presentation/providers/more_providers.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/decimal_converter.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/network/result.dart';
import '../widgets/pos_numeric_keypad.dart';
import 'payment_method_screen.dart';

class PosPaymentScreen extends ConsumerStatefulWidget {
  const PosPaymentScreen({super.key});

  @override
  ConsumerState<PosPaymentScreen> createState() => _PosPaymentScreenState();
}

class _PosPaymentScreenState extends ConsumerState<PosPaymentScreen> {
  String _amount = '0';
  final bool _isProcessing = false;

  void _onKeyTap(String value) {
    setState(() {
      if (value == 'backspace') {
        if (_amount.length > 1) {
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = '0';
        }
      } else if (value == '.') {
        if (!_amount.contains('.')) {
          _amount += value;
        }
      } else {
        // Add number
        if (_amount == '0') {
          _amount = value;
        } else {
          // Limit to 2 decimal places
          if (_amount.contains('.')) {
            final parts = _amount.split('.');
            if (parts[1].length < 2) {
              _amount += value;
            }
          } else {
            _amount += value;
          }
        }
      }
    });
  }

  void _clearAmount() {
    setState(() {
      _amount = '0';
    });
  }

  double get _numericAmount {
    return double.tryParse(_amount) ?? 0.0;
  }

  String _generatePaymentUrl(double amount) {
    final data = ref.read(profileProvider).valueOrNull;
    Profile? profile;
    switch (data) {
      case Ok<Profile?>():
        profile = data.data;
      case Error<Profile?>():
      case null:
    }
    if (profile == null) {
      showErrorDialog(
        context: AppNav.navKey.currentContext!,
        message: 'Failed to retrieve profile information',
      );
      return '';
    }
    if (profile.wallet?.address == null) {
      showErrorDialog(
        context: AppNav.navKey.currentContext!,
        message: 'Please connect your wallet first',
      );
      return '';
    }
    // Create payment payload
    final payload = {
      'amount': _numericAmount,
      'walletAddress': profile.wallet!.address,
      'merchantName': profile.fullName ?? 'Merchant',
    };

    // Convert to JSON and base64 encode
    final jsonStr = jsonEncode(payload);
    final encodedData = base64Url.encode(utf8.encode(jsonStr));

    // Return payment URL
    print('Generated payment URL: soho://payment-screen?data=$encodedData');
    return 'soho:///payment-screen?data=$encodedData';
  }

  Future<void> _handlePayment() async {
    if (_numericAmount <= 0) {
      showErrorDialog(
        context: context,
        message: 'Please enter a valid amount greater than zero.',
      );
      return;
    }

    // Generate payment URL
    final paymentUrl = _generatePaymentUrl(_numericAmount);
    if (paymentUrl.isEmpty) return;

    // Record the payment start time
    final paymentStartTime = DateTime.now();

    // Navigate to payment method screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          paymentUrl: paymentUrl,
          amount: _numericAmount,
          paymentStartTime: paymentStartTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        title: Text('POS Payment', style: s18W600(context)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.c757575),
            onPressed: _clearAmount,
            tooltip: 'Clear',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.paddingMedium),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [
                  //     AppColors.primaryLight.withOpacity(0.1),
                  //     AppColors.primaryVariantLight.withOpacity(0.05),
                  //   ],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryLight.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Amount to Charge',
                      style: s14W400(
                        context,
                      ).copyWith(color: AppColors.c757575, letterSpacing: 0.5),
                    ),
                    const VerticalSpace(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '\$',
                            style: s28W600(context).copyWith(
                              fontSize: 32,
                              color: AppColors.primaryVariantLight,
                            ),
                          ),
                        ),
                        const HorizontalSpace(8),
                        Text(
                          _amount,
                          style: s28W600(context).copyWith(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryVariantLight,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const VerticalSpace(8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _numericAmount > 0
                            ? AppColors.jungleGreen.withValues(alpha: 0.1)
                            : AppColors.c757575.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _numericAmount > 0
                            ? DecimalConverter.formatAmount(_numericAmount)
                            : 'Enter amount',
                        style: s14W600(context).copyWith(
                          color: _numericAmount > 0
                              ? AppColors.jungleGreen
                              : AppColors.c757575,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Numeric Keypad
              PosNumericKeypad(onTap: _onKeyTap),
              const VerticalSpace(20),
              // Charge Button
              AppPrimaryButton(
                title: _isProcessing ? 'Processing...' : 'Pay Now',
                isExpanded: true,
                onTap: _isProcessing || _numericAmount <= 0
                    ? null
                    : _handlePayment,
              ),
              const VerticalSpace(10),
            ],
          ),
        ),
      ),
    );
  }
}
