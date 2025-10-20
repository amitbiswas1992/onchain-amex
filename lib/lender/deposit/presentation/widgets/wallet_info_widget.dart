import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class WalletAddressWidget extends StatelessWidget {
  const WalletAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cF5F5F5,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFF4ECDC4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const HorizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('0x884...Ec70', style: s16W600(context))],
            ),
          ),
          InkWell(
            onTap: () {
              Clipboard.setData(const ClipboardData(text: '0x884...Ec70'));
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.copy, size: 20, color: AppColors.c757575),
            ),
          ),
        ],
      ),
    );
  }
}
