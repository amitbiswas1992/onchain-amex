import 'package:flutter/material.dart';
import '../utils/sizebox_util.dart';
import 'texts/text_styles.dart';

class TitleAndWidget extends StatelessWidget {
  final String titleText;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final Widget widget;
  final String? subTitle;

  const TitleAndWidget({
    super.key,
    required this.titleText,
    required this.widget,
    this.titleColor,
    this.titleStyle,
    this.subTitle,
    this.subTitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTitleStyle = titleStyle ??
        s14W500(context);

    final defaultSubTitleStyle = subTitleStyle ??
        const TextStyle(
          color: Color(0xFF8897AE),
          fontSize: 14,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subTitle == null)
          Text(
            titleText,
            style: defaultTitleStyle,
          )
        else
          Text.rich(
            TextSpan(
              text: '$titleText ', // Added space before subtitle
              style: defaultTitleStyle,
              children: [
                TextSpan(
                  text: subTitle ?? '', // Ensure non-null
                  style: defaultSubTitleStyle,
                ),
              ],
            ),
            softWrap: true,
          ),
        const VerticalSpace(6),
        widget,
      ],
    );
  }
}
