import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/string_extension.dart';
import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/utils/decimal_converter.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';

class PosPaymentSuccessScreen extends StatelessWidget {
  final String borrowerName;
  final double amount;
  final String txHash;
  final String time;

  const PosPaymentSuccessScreen({
    super.key,
    this.borrowerName = 'Customer',
    this.amount = 0.0,
    this.txHash = '',
    this.time = '',
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor:
          isTablet ? const Color(0xFFF5F5F5) : AppColors.backgroundLight,
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
      title: Text('Payment Success', style: s18W600(context)),
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
      children: [
        // Success Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFD4EDDA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF28A745),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 24),
              ),
              const HorizontalSpace(12),
              const Text(
                'Payment Received',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF155724),
                ),
              ),
            ],
          ),
        ),
        const VerticalSpace(40),
        // Amount Section
        const Text(
          "You've received",
          style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
        ),
        const VerticalSpace(12),
        Text(
          '\$${DecimalConverter.formatAmount(amount)}',
          style: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const VerticalSpace(48),
        // Transaction Details Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cE0E0E0, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transaction Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const VerticalSpace(20),
              _DetailRow(label: 'From:', value: _truncateAddress(txHash)),
              const VerticalSpace(16),
              _DetailRow(
                label: 'Time:',
                value: uiTimeFormat.format(
                  time.toDateFromMillisecondsSinceEpoch()!,
                ),
              ),
              const VerticalSpace(16),
              _DetailRow(
                label: 'Date:',
                value: uiDateFormat.format(
                  time.toDateFromMillisecondsSinceEpoch()!,
                ),
              ),
            ],
          ),
        ),
        VerticalSpace(isMobile ? 40 : 48),
        // Done Button
        SizedBox(
          width: double.infinity,
          child: Builder(
            builder: (context) => AppPrimaryButton(
              title: 'Done',
              isExpanded: true,
              onTap: () {
                context.goNamed(RtNm.merchantHomeScreen);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _truncateAddress(String address) {
    if (address.isEmpty) return 'Unknown';
    if (address.length <= 20) return address;
    return '${address.substring(0, 10)}........${address.substring(address.length - 6)}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF757575),
          ),
        ),
        const HorizontalSpace(16),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
