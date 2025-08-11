import 'package:flutter/material.dart';

import 'text_styles.dart';

class LargeNumberText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final TextAlign? textAlign;
  final Color? color;

  const LargeNumberText({
    super.key,
    required this.text,
    this.fontSize,
    this.textAlign,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: s54w600(context).copyWith(color: color, fontSize: fontSize),
    );
  }
}
