import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class NumericKeypadWidget extends StatelessWidget {
  final Function(String) onTap;

  const NumericKeypadWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cF5F5F5.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // First row: 1, 2, 3
          Row(
            children: [
              _buildKey(context, '1', 'ABC'),
              const HorizontalSpace(16),
              _buildKey(context, '2', 'DEF'),
              const HorizontalSpace(16),
              _buildKey(context, '3', ''),
            ],
          ),
          const VerticalSpace(16),
          // Second row: 4, 5, 6
          Row(
            children: [
              _buildKey(context, '4', 'GHI'),
              const HorizontalSpace(16),
              _buildKey(context, '5', 'JKL'),
              const HorizontalSpace(16),
              _buildKey(context, '6', 'MNO'),
            ],
          ),
          const VerticalSpace(16),
          // Third row: 7, 8, 9
          Row(
            children: [
              _buildKey(context, '7', 'PQRS'),
              const HorizontalSpace(16),
              _buildKey(context, '8', 'TUV'),
              const HorizontalSpace(16),
              _buildKey(context, '9', 'WXYZ'),
            ],
          ),
          const VerticalSpace(16),
          // Fourth row: *, 0, backspace
          Row(
            children: [
              _buildKey(context, '*', '#'),
              const HorizontalSpace(16),
              _buildKey(context, '0', ''),
              const HorizontalSpace(16),
              _buildBackspaceKey(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(BuildContext context, String number, String letters) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(number);
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(number, style: s18W600(context)),
              if (letters.isNotEmpty) ...[
                const VerticalSpace(2),
                Text(
                  letters,
                  style: s12W400(context).copyWith(color: AppColors.c757575),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap('backspace');
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: const Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 24,
              color: AppColors.c757575,
            ),
          ),
        ),
      ),
    );
  }
}
