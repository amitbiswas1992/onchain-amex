import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../providers/home_providers.dart';
import '../widgets/bottom_nav_item.dart';

class ShellScreen extends ConsumerStatefulWidget {
  final Widget child;

  const ShellScreen({super.key, required this.child});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  void _onItemTapped(int index) {
    final selectedIndex = ref.read(bottomNavSelectedIndexProvider);
    if (selectedIndex != index) {
      switch (index) {
        case 0:
          AppNav.goRouter.go(RtNm.homeScreen);
        case 1:
          AppNav.goRouter.go(RtNm.cardsScreen);
        case 2:
          AppNav.goRouter.go(RtNm.spendScreen);
        case 3:
          AppNav.goRouter.go(RtNm.transactionsScreen);
        case 4:
          AppNav.goRouter.go(RtNm.moreScreen);
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
            Container(
              height: 1,
              color: Colors.black12,
            ),
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
                    label: 'Cards',
                    svgPath: 'assets/icons/bottom_nav/cards.svg',
                    isSelected: selectedIndex == 1,
                    onItemTap: () {
                      _onItemTapped(1);
                    },
                  ),
                ),
                Expanded(
                  child: BottomNavItem(
                    label: 'Spends',
                    svgPath: 'assets/icons/bottom_nav/spends.svg',
                    isSelected: selectedIndex == 2,
                    largeIcon: true,
                    onItemTap: () {
                      _onItemTapped(2);
                    },
                  ),
                ),
                Expanded(
                  child: BottomNavItem(
                    label: 'Transactions',
                    svgPath: 'assets/icons/bottom_nav/transactions.svg',
                    isSelected: selectedIndex == 3,
                    onItemTap: () {
                      _onItemTapped(3);
                    },
                  ),
                ),
                Expanded(
                  child: BottomNavItem(
                    label: 'More',
                    svgPath: 'assets/icons/bottom_nav/more.svg',
                    isSelected: selectedIndex == 4,
                    onItemTap: () {
                      _onItemTapped(4);
                    },
                  ),
                ),
              ],
            ),
            // const VerticalSpace(AppValues.paddingMedium),
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
