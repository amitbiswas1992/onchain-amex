import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../controllers/debouce_query_controller.dart';

class DepositAmountInputWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;

  const DepositAmountInputWidget({super.key, required this.controller});

  @override
  ConsumerState<DepositAmountInputWidget> createState() =>
      _DepositAmountInputWidgetState();
}

class _DepositAmountInputWidgetState
    extends ConsumerState<DepositAmountInputWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = '0.0';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Enter Amount', style: s16W600(context)),
        const VerticalSpace(16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              TextFormField(
                controller: widget.controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (value) => ref
                    .read(debouceQueryControllerProvider.notifier)
                    .setAmount(double.tryParse(value) ?? 0.0),
                textAlign: TextAlign.center,
                style: s28W600(context).copyWith(fontSize: 54),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '0.0',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onTap: () {
                  if (widget.controller.text == '0.0') {
                    widget.controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
