import 'package:flutter/material.dart';

class CustomValueIndicatorShape extends SliderComponentShape {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;

  const CustomValueIndicatorShape({
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.green,
    this.borderWidth = 2,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromHeight(36); // Slightly taller for the arrow
  }

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

    final textSize = labelPainter.size;

    // Main bubble rectangle
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 38), // Position above thumb
        width: textSize.width + padding.horizontal,
        height: textSize.height + padding.vertical,
      ),
      const Radius.circular(6),
    );

    // Arrow dimensions
    const double arrowWidth = 10;
    const double arrowHeight = 6;

    // Arrow path (triangle)
    final Path arrowPath = Path()
      ..moveTo(center.dx - arrowWidth / 2, rect.bottom)
      ..lineTo(center.dx + arrowWidth / 2, rect.bottom)
      ..lineTo(center.dx, rect.bottom + arrowHeight)
      ..close();

    final Paint fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Draw filled background
    canvas.drawRRect(rect, fillPaint);
    canvas.drawPath(arrowPath, fillPaint);

    // Draw border
    canvas.drawRRect(rect, borderPaint);
    canvas.drawPath(arrowPath, borderPaint);

    // Draw the text centered inside bubble
    labelPainter.paint(
      canvas,
      Offset(
        rect.left + (rect.width - textSize.width) / 2,
        rect.top + (rect.height - textSize.height) / 2,
      ),
    );
  }
}
