import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class CardInfoTile extends StatelessWidget {
  final String title;
  final String value;

  const CardInfoTile({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppValues.paddingSmall + 2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: s12W400(context),),
                const VerticalSpace(AppValues.paddingSmall),
                Text(value, style: s14W600(context),),
              ],
            ),
          ),
          const HorizontalSpace(AppValues.paddingSmall),
          InkResponse(
            onTap: () {},
            child: const Icon(Icons.copy),
          ),
        ],
      ),
    );
  }
}
