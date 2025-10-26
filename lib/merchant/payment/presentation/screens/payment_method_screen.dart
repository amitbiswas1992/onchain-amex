import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../borrower/more/presentation/providers/more_providers.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../lender/lender_transactions/presentation/providers/transaction_providers.dart';
import '../providers/payment_verification_provider.dart';
import '../widgets/nfc_payment_widget.dart';
import '../widgets/qr_payment_widget.dart';
import 'pos_payment_error_screen.dart';
import 'pos_payment_success_screen.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  final String paymentUrl;
  final double amount;
  final DateTime paymentStartTime;
  final bool isNfcAvailable;

  const PaymentMethodScreen({
    super.key,
    required this.paymentUrl,
    required this.amount,
    required this.paymentStartTime,
    required this.isNfcAvailable,
  });

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Start payment verification polling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(
        paymentVerificationProvider({
          'amount': widget.amount,
          'startTime': widget.paymentStartTime,
        }).notifier,
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _stopEmulation() async {
    try {
      await ref.read(nfcHceProvider).stopNfcHce();
    } catch (e) {
      print('NFC HCE stop error: $e');
    }
  }

  void _handleCancel() {
    _stopEmulation();
    // Cancel the payment verification
    ref
        .read(
          paymentVerificationProvider({
            'amount': widget.amount,
            'startTime': widget.paymentStartTime,
          }).notifier,
        )
        .manualCancel();

    AppNav.goRouter.pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // Listen to payment verification status
    ref.listen(
      paymentVerificationProvider({
        'amount': widget.amount,
        'startTime': widget.paymentStartTime,
      }),
      (previous, next) {
        if (next.status == PaymentVerificationStatus.success) {
          ref.invalidate(merchantProfileProvider);
          ref.invalidate(transactionHistoryProvider);
          // Navigate to success screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PosPaymentSuccessScreen(
                borrowerName:
                    next.matchedTransaction?.borrowerName ?? 'Customer',
                amount: widget.amount,
                txHash: next.matchedTransaction?.txHash ?? '',
                time: next.matchedTransaction?.timestamp ?? '',
              ),
            ),
          );
        } else if (next.status == PaymentVerificationStatus.timeout ||
            next.status == PaymentVerificationStatus.failed) {
          ref.invalidate(merchantProfileProvider);
          ref.invalidate(transactionHistoryProvider);
          // Navigate to error screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PosPaymentErrorScreen(
                expectedAmount: widget.amount,
                errorMessage:
                    next.errorMessage ?? 'Payment verification failed',
              ),
            ),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor:
          isTablet ? const Color(0xFFF5F5F5) : AppColors.backgroundLight,
      appBar: isTablet
          ? null
          : AppBar(
              backgroundColor: AppColors.backgroundLight,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: _handleCancel,
              ),
              title: Text('Payment Method', style: s18W600(context)),
              centerTitle: true,
            ),
      body: SafeArea(
        child: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    final verificationState = ref.watch(
      paymentVerificationProvider({
        'amount': widget.amount,
        'startTime': widget.paymentStartTime,
      }),
    );

    return Column(
      children: [
        // Payment Verification Status Banner
        if (verificationState.status == PaymentVerificationStatus.waiting)
          _buildVerificationBanner(),

        // Tab Bar
        if (widget.isNfcAvailable)
          Container(
            margin: const EdgeInsets.all(AppValues.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.cF5F5F5,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.c757575,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(icon: Icon(Icons.qr_code_2), text: 'QR Payment'),
                Tab(icon: Icon(Icons.nfc), text: 'NFC Payment'),
              ],
            ),
          ),
        // Tab Content
        if (widget.isNfcAvailable)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                QrPaymentWidget(paymentUrl: widget.paymentUrl),
                NfcPaymentWidget(paymentUrl: widget.paymentUrl),
              ],
            ),
          )
        else
          Expanded(
            child: QrPaymentWidget(paymentUrl: widget.paymentUrl),
          ),
        // Cancel Button
        Padding(
          padding: const EdgeInsets.all(AppValues.paddingMedium),
          child: AppSecondaryButton(
            title: 'Cancel',
            onTap: () {
              _handleCancel();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Center(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cE0E0E0, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tab Bar
            Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cF5F5F5,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.c757575,
                labelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.qr_code_2, size: 32),
                    text: 'QR Payment',
                  ),
                  Tab(icon: Icon(Icons.nfc, size: 32), text: 'NFC Payment'),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  QrPaymentWidget(paymentUrl: widget.paymentUrl),
                  NfcPaymentWidget(paymentUrl: widget.paymentUrl),
                ],
              ),
            ),
            // Cancel Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: AppSecondaryButton(
                title: 'Cancel',
                onTap: () {
                  _handleCancel();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.all(AppValues.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Waiting for payment... Checking transactions',
              style: s14W400(context).copyWith(color: Colors.blue.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
