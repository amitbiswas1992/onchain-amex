import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../resources/spends_strings.dart';
import '../widgets/scan_and_pay_page.dart';
import '../widgets/spends_nfc_page.dart';

class SpendsScreen extends ConsumerStatefulWidget {
  const SpendsScreen({super.key});

  @override
  ConsumerState createState() => _SpendsScreenState();
}

class _SpendsScreenState extends ConsumerState<SpendsScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpace(padding.top),
            const VerticalSpace(AppValues.paddingMedium),
            SizedBox(
              height: 40,
              child: TabBar(
                controller: _tabController,
                labelStyle: s14W500(context).copyWith(color: Colors.white),
                labelPadding: const EdgeInsets.only(
                  left: AppValues.paddingLarge,
                  right: AppValues.paddingLarge,
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
                tabs: const [
                  Tab(
                    text: nfc,
                  ),
                  Tab(
                    text: scanAndPay,
                  ),
                ],
                onTap: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            const VerticalSpace(AppValues.paddingLarge),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  _tabController.animateTo(page);
                },
                children: const [
                  SpendsNfcPage(),
                  ScanAndPayPage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
