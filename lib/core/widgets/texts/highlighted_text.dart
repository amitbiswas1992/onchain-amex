import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String matchText;
  final Color highlightColor;
  final TextStyle? style;

  const HighlightedText({
    super.key,
    required this.text,
    required this.matchText,
    this.highlightColor = Colors.yellow,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (matchText.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerMatch = matchText.toLowerCase();

    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerMatch, start);
      if (index < 0) {
        spans.add(TextSpan(
          text: text.substring(start),
          style: style,
        ),);
        break;
      }

      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: style,
        ),);
      }

      spans.add(TextSpan(
        text: text.substring(index, index + matchText.length),
        style: style?.copyWith(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.bold,
        ) ??
            TextStyle(
              backgroundColor: highlightColor,
              fontWeight: FontWeight.bold,
            ),
      ),);

      start = index + matchText.length;
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.start,
    );
  }
}
