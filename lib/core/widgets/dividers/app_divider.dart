import 'package:flutter/material.dart';

import '../../utils/functions.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: isLightTheme(context) ? Colors.black12 : Colors.white12,
    );
  }
}
