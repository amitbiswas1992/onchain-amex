import 'package:flutter/material.dart';


class LightCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final double radius;

  const LightCard({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.width,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .01,
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
