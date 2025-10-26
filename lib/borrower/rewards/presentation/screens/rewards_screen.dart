import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../widgets/challenges_page.dart';
import '../widgets/rewards_page.dart';
import '../widgets/tires_page.dart';
import 'rewards_strings.dart';

class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(initialPage: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: rewards,
        onLeadingPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.paddingMedium,
            ),
            child: Column(
              children: [
                // VerticalSpace(padding.top),
                const VerticalSpace(AppValues.paddingMedium),
                SizedBox(
                  height: 36,
                  child: TabBar(
                    controller: _tabController,
                    labelStyle: s14W500(context).copyWith(color: Colors.white),
                    labelPadding: const EdgeInsets.only(
                      left: AppValues.paddingMedium,
                      right: AppValues.paddingMedium,
                      top: 5,
                    ),
                    unselectedLabelStyle: s14W500(context),
                    indicator: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(56),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerHeight: 0,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    physics: const NeverScrollableScrollPhysics(),
                    tabs: const [
                      Tab(
                        text: tires,
                      ),
                      Tab(
                        text: rewards,
                      ),
                      Tab(
                        text: challenges,
                      ),
                    ],
                    onTap: (index) async {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
                const VerticalSpace(AppValues.paddingLarge),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                _tabController.animateTo(page);
              },
              // physics: const NeverScrollableScrollPhysics(),
              children: const [
                TiresPage(),
                RewardsPage(),
                ChallengesPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
