import 'package:flutter/material.dart';

import '../../../../core/utils/sizebox_util.dart';

class SplashWidget extends StatelessWidget {
  final String? message;

  const SplashWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width / 4.5,
              ),
              child: Image.asset(
                'assets/logos/advisify.png',
              ),
            ),
          ),
        ),
        Text(
          message ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.5,
            letterSpacing: 0.4 * 14,
            textBaseline: TextBaseline.alphabetic,
          ),
        ),
        const VerticalSpace(32),
      ],
    );
  }
}
