import 'package:flutter/material.dart';

class HollowCircle extends StatelessWidget {
  final Color color;
  final Color hollowColor;
  final double? size;
  final double? hollowSize;

  const HollowCircle({
    super.key,
    required this.color,
    required this.hollowColor,
    this.size,
    this.hollowSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ??   12,
      width: size ?? 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Container(
        height: hollowSize ?? 6,
        width: hollowSize ?? 6,
        decoration: BoxDecoration(
          color: hollowColor,
          borderRadius: BorderRadius.circular(hollowSize ?? 6),
        ),
      ),
    );
  }
}
