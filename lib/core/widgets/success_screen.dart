import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';

class SuccessScreen extends ConsumerWidget {
  const SuccessScreen({
    super.key,
    required this.title,
    required this.subtitle,
    this.txHash,
  });

  final String title;
  final String subtitle;
  final String? txHash;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.paddingMedium),
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/images/confirm.png', width: 80, height: 80),
              const VerticalSpace(24),
              Text(title, style: s28W600(context), textAlign: TextAlign.center),
              const VerticalSpace(16),
              Text(
                subtitle,
                style: s14W400(context).copyWith(color: AppColors.c757575),
                textAlign: TextAlign.center,
              ),
              if (txHash != null) ...[
                const VerticalSpace(12),
                Text(
                  'Tx: ${txHash!.substring(0, 10)}...',
                  style: s12W400(context).copyWith(color: AppColors.c757575),
                  textAlign: TextAlign.center,
                ),
              ],
              const Spacer(),
              AppPrimaryButton(
                title: 'Return Home',
                isExpanded: true,
                onTap: () {
                  HapticFeedback.lightImpact();
                  AppNav.goRouter.go(RtNm.lenderHomeScreen);
                },
              ),
              const VerticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}
