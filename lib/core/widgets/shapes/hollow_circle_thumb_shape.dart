import 'package:flutter/material.dart';

class HollowCircleThumbShape extends SliderComponentShape {
  final Color hollowColor;
  const HollowCircleThumbShape({required this.hollowColor});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(18, 18);

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // Fill white background inside the thumb
    final Paint fillPaint = Paint()
      ..color = hollowColor
      ..style = PaintingStyle.fill;

    // Border paint
    final Paint borderPaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw white center
    canvas.drawCircle(center, 10, fillPaint);

    // Draw border on top
    canvas.drawCircle(center, 10, borderPaint);
  }
}
