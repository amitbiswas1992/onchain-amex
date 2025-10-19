import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';

class MetamaskHeaderWidget extends StatelessWidget {
  const MetamaskHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset('assets/icons/metamask.svg'),
            ),
          ),
        ),
        const SizedBox(height: AppValues.paddingMedium),
        const Text(
          'Metamask',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}