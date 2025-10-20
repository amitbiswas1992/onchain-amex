import 'package:flutter/material.dart';

import '../../../../core/resources/app_colors.dart';

class RoleTabWidget extends StatelessWidget {
  const RoleTabWidget({
    super.key,
    required this.tabController,
  });

  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.secondaryDark.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: Colors.white,
            indicatorWeight: 0,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            indicatorPadding: const EdgeInsets.all(4.0),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12.0),
            ),
            splashBorderRadius: BorderRadius.circular(12.0),
            controller: tabController,
            tabs: const [
              Tab(
                text: 'Borrower',
              ),
              Tab(
                text: 'Lender',
              ),
              Tab(
                text: 'Merchant',
              ),
            ],
            onTap: (value) async {},
          ),
        ),
      ),
    );
  }
}
