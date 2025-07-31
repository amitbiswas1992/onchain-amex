import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool? infiniteMaxLen;

  const TitleText({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.infiniteMaxLen,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: infiniteMaxLen == true ? null : 1,
      overflow: infiniteMaxLen == true ? null : TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
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
