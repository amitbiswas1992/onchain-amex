import 'package:flutter/material.dart';


class LightCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final double radius;
  final Color? color;

  const LightCard({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.width,
    this.radius = 16, this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .01,
      color: color,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: SizedBox(
          height: height,
          width: width ?? double.infinity,
          child: child,
        ),
      ),
    );
  }
}
