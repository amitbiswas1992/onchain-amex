import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../utils/sizebox_util.dart';
import 'title_text.dart';

class ColumnTitleValueWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color? titleColor;
  final Color? valueColor;

  const ColumnTitleValueWidget({
    super.key,
    required this.title,
    required this.value,
    this.titleColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SubTitleText(
          text: title,
          color: titleColor ?? AppColors.primaryLight,
        ),
        const VerticalSpace(2),
        Text(
          value,
          style: TextStyle(
            color: titleColor ?? AppColors.primaryLight,
          ),
        ),
      ],
    );
  }
}
