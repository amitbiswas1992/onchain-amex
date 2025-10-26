import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class PosNumericKeypad extends StatelessWidget {
  final Function(String) onTap;

  const PosNumericKeypad({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLightTheme(context)
            ? const Color(0xFFF5F5F5)
            : AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // First row: 1, 2, 3
          Row(
            children: [
              _buildKey(context, '1'),
              const HorizontalSpace(12),
              _buildKey(context, '2'),
              const HorizontalSpace(12),
              _buildKey(context, '3'),
            ],
          ),
          const VerticalSpace(12),
          // Second row: 4, 5, 6
          Row(
            children: [
              _buildKey(context, '4'),
              const HorizontalSpace(12),
              _buildKey(context, '5'),
              const HorizontalSpace(12),
              _buildKey(context, '6'),
            ],
          ),
          const VerticalSpace(12),
          // Third row: 7, 8, 9
          Row(
            children: [
              _buildKey(context, '7'),
              const HorizontalSpace(12),
              _buildKey(context, '8'),
              const HorizontalSpace(12),
              _buildKey(context, '9'),
            ],
          ),
          const VerticalSpace(12),
          // Fourth row: ., 0, backspace
          Row(
            children: [
              _buildKey(context, '.'),
              const HorizontalSpace(12),
              _buildKey(context, '0'),
              const HorizontalSpace(12),
              _buildBackspaceKey(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(BuildContext context, String number) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap(number);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: isLightTheme(context)
                ? const Color(0xFFF5F5F5)
                : AppColors.backgroundDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLightTheme(context)
                  ? AppColors.borderColor
                  : AppColors.c757575,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: s28W600(context).copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                // color: AppColors.c212121,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap('backspace');
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.errorLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.errorLight.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 28,
              color: AppColors.errorLight,
            ),
          ),
        ),
      ),
    );
  }
}
