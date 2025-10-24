import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../providers/home_providers.dart';
import '../widgets/bottom_nav_item.dart';

class LenderShellScreen extends ConsumerStatefulWidget {
  final Widget child;

  const LenderShellScreen({super.key, required this.child});

  @override
  ConsumerState<LenderShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<LenderShellScreen> {
  void _onItemTapped(int index) {
    final selectedIndex = ref.read(bottomNavSelectedIndexProvider);
    if (selectedIndex != index) {
      switch (index) {
        case 0:
          AppNav.goRouter.go(RtNm.lenderHomeScreen);

        case 1:
          AppNav.goRouter.go(RtNm.lenderMoreScreen);
      }
    }
    ref.read(bottomNavSelectedIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(bottomNavSelectedIndexProvider);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 1, color: Colors.black12),
            const VerticalSpace(14),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: BottomNavItem(
                    label: 'Home',
                    svgPath: 'assets/icons/bottom_nav/home.svg',
                    isSelected: selectedIndex == 0,
                    onItemTap: () {
                      _onItemTapped(0);
                    },
                  ),
                ),
                Expanded(
                  child: BottomNavItem(
                    label: 'More',
                    svgPath: 'assets/icons/bottom_nav/more.svg',
                    isSelected: selectedIndex == 1,
                    onItemTap: () {
                      _onItemTapped(1);
                    },
                  ),
                ),
              ],
            ),
            const VerticalSpace(AppValues.paddingSmall),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: selectedIndex,
      //   onTap: _onItemTapped,
      //   elevation: 5,
      //   selectedItemColor: theme.colorScheme.onSurface,
      //   selectedIconTheme: IconThemeData(
      //     color: theme.colorScheme.onSurface,
      //   ),
      //   unselectedIconTheme: IconThemeData(
      //     color: isLightTheme(context) ? Colors.black: AppColors.cAFBACA,
      //   ),
      //   selectedLabelStyle: s14W600(context),
      //   unselectedLabelStyle: s14W400(context),
      //   showSelectedLabels: true,
      //   showUnselectedLabels: true,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: SizedBox(
      //         height: 24,
      //         width: 24,
      //         child: SvgPicture.asset(
      //           'assets/icons/bottom_nav/home.svg',
      //           height: 24,
      //           width: 24,
      //         ),
      //       ),
      //       label: "Home",
      //
      //     ),
      //     BottomNavigationBarItem(
      //       icon: SizedBox(
      //         height: 24,
      //         width: 24,
      //         child: SvgPicture.asset(
      //           'assets/icons/bottom_nav/cards.svg',
      //           height: 24,
      //           width: 24,
      //         ),
      //       ),
      //       label: "Cards",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: SizedBox(
      //         height: 44,
      //         width: 44,
      //         child: SvgPicture.asset(
      //           'assets/icons/bottom_nav/spends.svg',
      //           height: 44,
      //           width: 44,
      //         ),
      //       ),
      //       label: "Spends",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: SizedBox(
      //         height: 24,
      //         width: 24,
      //         child: SvgPicture.asset(
      //           'assets/icons/bottom_nav/transactions.svg',
      //           height: 24,
      //           width: 24,
      //         ),
      //       ),
      //       label: "Transactions",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: SizedBox(
      //         height: 24,
      //         width: 24,
      //         child: SvgPicture.asset(
      //           'assets/icons/bottom_nav/more.svg',
      //           height: 24,
      //           width: 24,
      //         ),
      //       ),
      //       label: "Profile",
      //     ),
      //   ],
      // ),
    );
  }
}
