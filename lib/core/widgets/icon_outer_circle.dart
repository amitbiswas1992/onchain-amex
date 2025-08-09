import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

class IconOuterCircle extends StatelessWidget {
  final double size;
  final Widget icon;
  final VoidCallback? onTap;

  const IconOuterCircle({
    super.key,
    this.size = 40,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          border: Border.all(
            color: const Color(0x1B38603D),
          ),
        ),
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }
}
