import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class WithdrawAmountInputWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const WithdrawAmountInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  ConsumerState<WithdrawAmountInputWidget> createState() =>
      _WithdrawAmountInputWidgetState();
}

class _WithdrawAmountInputWidgetState
    extends ConsumerState<WithdrawAmountInputWidget> {
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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
                onChanged: widget.onChanged,
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
