import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/containers/app_card.dart';
import '../../../../core/widgets/texts/large_number_text.dart';
import '../resources/home_strings.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_available_to_spend.dart';
import '../widgets/home_credit_score_and_xp_points.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: isLightTheme(context) ? const Color(0xFFF5F5F5) : const Color(0xFF121212),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.paddingMedium,
          ),
          child: Column(
            children: [
              VerticalSpace(padding.top),
              const VerticalSpace(AppValues.paddingMedium),
              HomeAppBar(
                onGiftTap: () {},
                onNotificationTap: () {},
                onProfileTap: () {},
                profileName: 'SH',
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const HomeAvailableToSpend(),
              const VerticalSpace(AppValues.paddingMedium),
              const HomeCreditScoreAndXpPoints(),
              const VerticalSpace(AppValues.paddingMedium),

            ],
          ),
        ),
      ),
    );
  }
}
