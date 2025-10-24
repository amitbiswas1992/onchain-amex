import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../resources/app_values.dart';
import '../utils/sizebox_util.dart';
import 'texts/text_styles.dart';

class Info extends StatelessWidget {
  final String content;

  const Info({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF1B3860).withValues(alpha: .24),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/icons/info.svg'),
          const HorizontalSpace(AppValues.paddingSmall),
          Expanded(child: Text(content, style: s14W400(context),),),
        ],
      ),
    );
  }
}
