import 'package:flutter/material.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/decimal_converter.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class PosPaymentErrorScreen extends StatelessWidget {
  final double expectedAmount;
  final String errorMessage;

  const PosPaymentErrorScreen({
    super.key,
    this.expectedAmount = 0.0,
    this.errorMessage = 'Payment verification timeout. Please try again.',
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: isTablet
          ? const Color(0xFFF5F5F5)
          : AppColors.backgroundLight,
      appBar: isTablet ? null : _buildMobileAppBar(context),
      body: SafeArea(
        child: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
      ),
    );
  }

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text('Payment Failed', style: s18W600(context)),
      centerTitle: true,
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppValues.paddingMedium),
      child: _buildContent(isMobile: true),
    );
  }

  Widget _buildTabletLayout() {
    return Center(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 800),
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cE0E0E0, width: 1),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: _buildContent(isMobile: false),
        ),
      ),
    );
  }

  Widget _buildContent({required bool isMobile}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Error Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFDC3545),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
              const HorizontalSpace(12),
              const Text(
                'Payment Not Verified',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF721C24),
                ),
              ),
            ],
          ),
        ),
        const VerticalSpace(40),
        // Expected Amount Section
        const Text(
          "Expected amount",
          style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
        ),
        const VerticalSpace(12),
        Text(
          '\$${DecimalConverter.formatAmount(expectedAmount)}',
          style: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const VerticalSpace(48),

        // Error Details Card
        VerticalSpace(isMobile ? 40 : 48),
        // Try Again Button
        SizedBox(
          width: double.infinity,
          child: Builder(
            builder: (context) => AppPrimaryButton(
              title: 'Try Again',
              isExpanded: true,
              onTap: () {
                // Pop back to payment method screen to retry
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        const VerticalSpace(12),
        // Cancel Button
        SizedBox(
          width: double.infinity,
          child: Builder(
            builder: (context) => OutlinedButton(
              onPressed: () {
                // Navigate back to POS payment screen
                Navigator.of(context).popUntil(
                  (route) =>
                      route.isFirst ||
                      route.settings.name?.contains('merchantPayment') == true,
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: AppColors.c757575, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cancel',
                style: s16W600(context).copyWith(color: AppColors.c757575),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
