import 'package:flutter/material.dart';

import '../utils/sizebox_util.dart';

class TitleAndWidget extends StatelessWidget {
  final String titleText;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final Widget widget;

  const TitleAndWidget({
    super.key,
    required this.titleText,
    required this.widget,
    this.titleColor,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: titleStyle ?? TextStyle(color: titleColor ?? Colors.white, fontSize: 16),
        ),
        const VerticalSpace(6),
        widget,
      ],
    );
  }
}
