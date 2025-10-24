import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/containers/icon_outer_circle.dart';
import '../../../../core/widgets/texts/highlighted_text.dart';
import '../../../../core/widgets/texts/large_number_text.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../data/models/latest_transaction.dart';

class LatestTransactionTile extends StatelessWidget {
  final LatestTransaction latestTransaction;

  const LatestTransactionTile({super.key, required this.latestTransaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconOuterCircle(
            size: 48,
            icon: SvgPicture.asset(
              'assets/icons/shopping_bag.svg',
            ),
          ),
          const HorizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: HighlightedText(
                        text: latestTransaction.title ?? '',
                        matchText: latestTransaction.match ?? '',
                        style: s16W500(context).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const HorizontalSpace(AppValues.paddingSmall),
                    LargeNumberText(
                      text: '${latestTransaction.amount ?? '0'} ${latestTransaction.currency ?? ''}',
                      fontSize: 16,
                    ),
                  ],
                ),
                const VerticalSpace(6),
                HighlightedText(
                  text: latestTransaction.address ?? '',
                  style: s11W400(context),
                  matchText: latestTransaction.match ?? '',
                ),
                const VerticalSpace(6),
                HighlightedText(
                  text: latestTransaction.date ?? '',
                  style: s11W600(context),
                  matchText: latestTransaction.match ?? '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
