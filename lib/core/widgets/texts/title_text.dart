import 'package:flutter/material.dart';

import 'text_styles.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLine;
  final TextOverflow? textOverflow;

  const TitleText({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLine,
    this.textOverflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: textOverflow,
      style: s24W500(context).copyWith(color: color),
    );
  }
}

class SubTitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const SubTitleText({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        overflow: overflow,
      ),
    );
  }
}
