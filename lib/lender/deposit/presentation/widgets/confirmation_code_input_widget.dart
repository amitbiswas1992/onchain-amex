import 'package:flutter/material.dart';

import '../../../../core/resources/app_colors.dart';

class ConfirmationCodeInputWidget extends StatelessWidget {
  final String code;

  const ConfirmationCodeInputWidget({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.cF5F5F5,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: index < code.length
                  ? AppColors.primaryLight
                  : AppColors.borderColor,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              index < code.length ? code[index] : '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }),
    );
  }
}
