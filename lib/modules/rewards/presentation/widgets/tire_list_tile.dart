import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/containers/deem_card.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class TireListTile extends StatelessWidget {
  final String iconPath;
  final Map<String, dynamic> item;
  final bool isCurrent;
  final VoidCallback? onTap;
  final Widget? badgeWidget;

  const TireListTile({
    super.key,
    required this.item,
    required this.isCurrent,
    this.onTap,
    required this.iconPath,
    this.badgeWidget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DeemCard(
        padding: const EdgeInsets.all(AppValues.paddingMedium),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              height: 56,
              width: 56,
            ),
            const HorizontalSpace(AppValues.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item['title'],
                        style: s18W600(context),
                      ),
                      const HorizontalSpace(6),
                      Visibility(
                        visible: isCurrent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.jungleGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          child: Text(
                            'Current',
                            style: s12W500(context).copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      const Flexible(child: SizedBox()),
                    ],
                  ),
                  const VerticalSpace(AppValues.paddingSmall),
                  ...(item['value'] as List<String>).map((val) {
                    return Row(
                      children: [
                        const Icon(
                          CupertinoIcons.check_mark,
                          color: AppColors.primaryVariantLight,
                          size: 24,
                        ),
                        const HorizontalSpace(4),
                        Text(
                          val,
                          style: s12W400(context),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
