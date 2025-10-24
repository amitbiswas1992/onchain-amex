import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/containers/deem_card.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../screens/rewards_strings.dart';
import 'tire_list_tile.dart';

class TiresPage extends ConsumerWidget {
  const TiresPage({super.key});

  final asstPaths = const [
    'assets/tires/bronze.svg',
    'assets/tires/silver.svg',
    'assets/tires/gold.svg',
    'assets/tires/platinum.svg',
  ];
  final tireMapList = const [
    {
      "title": 'Bronze',
      "value": [
        "1% cashback on all purchases",
        "Basic customer support",
        "Monthly credit reports",
      ],
    },
    {
      'title': 'Silver',
      "value": [
        "1.5% cashback on all purchases",
        "Priority customer support",
        "Gas fee rebates up to \$10/month",
        "Weekly credit score updates",
      ],
    },
    {
      'title': "Gold",
      "value": [
        "2% cashback on all purchases",
        "Premium customer support",
        "Gas fee rebates up to \$25/month",
        "Daily credit score updates",
        "Exclusive merchant discounts",
      ],
    },
    {
      'title': 'Platinum',
      "value": [
        "3% cashback on all purchases",
        "VIP customer support",
        "Gas fee rebates up to \$50/month",
        "Real-time credit monitoring",
        "Premium merchant partnerships",
        "Custom credit limits",
      ],
    }
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DeemCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppValues.paddingMedium,
                vertical: 20,
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/tires/gold.svg',
                    height: 56,
                    width: 56,
                  ),
                  const VerticalSpace(AppValues.paddingLarge),
                  const TitleText(text: goldTire),
                  const VerticalSpace(AppValues.paddingLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        nextTire,
                        style: s14W400(context),
                      ),
                      Text(
                        '786/2000',
                        style: s14W600(context).copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  const AppProgressBar(target: 100, achievement: 30),
                ],
              ),
            ),
            const VerticalSpace(AppValues.paddingMedium),
            Text(
              tireList,
              style: s18W600(context),
            ),
            const VerticalSpace(AppValues.paddingMedium),
            ListView.builder(
              itemCount: tireMapList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsetsGeometry.only(
                    bottom: AppValues.paddingSmall,
                  ),
                  child: TireListTile(
                    iconPath: asstPaths[index],
                    item: tireMapList[index],
                    isCurrent: index == 2,
                    onTap: () {},
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
