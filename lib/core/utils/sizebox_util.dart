import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  final double height;

  const VerticalSpace(this.height ,{super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}


class HorizontalSpace extends StatelessWidget {
  final double width;

  const HorizontalSpace(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
