// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/resources/app_colors.dart';

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size.width < 450) {
      return ScaffoldWithNavigationBar(
        body: navigationShell,
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    } else {
      return ScaffoldWithNavigationRail(
        body: navigationShell,
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
      );
    }
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onDestinationSelected,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: const TextStyle(color: AppColors.c757575),
        selectedFontSize: 13,
        selectedItemColor: Colors.black,
        unselectedItemColor: AppColors.c757575,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/bottom_nav/home.svg',
              color: AppColors.c757575,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/bottom_nav/home.svg',
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/bottom_nav/wallet.svg',
              color: AppColors.c757575,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/bottom_nav/wallet.svg',
              color: Colors.black,
            ),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/bottom_nav/transactions.svg',
              color: AppColors.c757575,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/bottom_nav/transactions.svg',
              color: Colors.black,
            ),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/bottom_nav/more.svg',
              color: AppColors.c757575,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icons/bottom_nav/more.svg',
              color: Colors.black,
            ),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _CustomNavigationRail(
            currentIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: AppColors.cE0E0E0,
          ),
          // This is the main content.
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _CustomNavigationRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const _CustomNavigationRail({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Logo
          Image.asset('assets/app_icons/logo.png', width: 30, height: 30),
          const SizedBox(height: 48),
          // Home
          _NavRailItem(
            iconPath: 'assets/icons/bottom_nav/home.svg',
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => onDestinationSelected(0),
          ),
          const SizedBox(height: 24),
          // Payment
          _NavRailItem(
            iconPath: 'assets/icons/bottom_nav/wallet.svg',
            label: 'Payment',
            isSelected: currentIndex == 1,
            onTap: () => onDestinationSelected(1),
          ),
          const SizedBox(height: 24),
          // Transactions
          _NavRailItem(
            iconPath: 'assets/icons/bottom_nav/transactions.svg',
            label: 'Transactions',
            isSelected: currentIndex == 2,
            onTap: () => onDestinationSelected(2),
          ),
          const SizedBox(height: 24),
          // More
          _NavRailItem(
            iconPath: 'assets/icons/bottom_nav/more.svg',
            label: 'More',
            isSelected: currentIndex == 3,
            onTap: () => onDestinationSelected(3),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _NavRailItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavRailItem({
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6B9B6E) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 28,
              height: 28,
              color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// class NavBar extends ConsumerWidget {
//   final int pageIndex;
//   final void Function(int) onTap;

//   const NavBar({
//     super.key,
//     required this.pageIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return BottomNavigationBar(
//       currentIndex: pageIndex,
//       onTap: onTap,
//       backgroundColor: Colors.white,
//       // backgroundColor: Theme.of(context).brightness == Brightness.light
//       //     ? Colors.white
//       //     : const Color(0xFF101015),
//       type: BottomNavigationBarType.fixed,
//       unselectedLabelStyle: const TextStyle(color: greyColor),
//       selectedFontSize: 13,
//       selectedItemColor: primaryColor,

//       // unselectedItemColor: Colors.transparent,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Photo(homeIcon, color: textSecondaryColor),
//           activeIcon: Photo(homeIcon, color: primaryColor),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Photo(applicationIcon, color: textSecondaryColor),
//           activeIcon: Photo(applicationIcon, color: primaryColor),
//           label: 'Request',
//         ),
//         BottomNavigationBarItem(
//           icon: Photo(inboxIcon, color: textSecondaryColor),
//           activeIcon: Photo(inboxIcon, color: primaryColor),
//           label: 'Inbox',
//         ),
//         BottomNavigationBarItem(
//           icon: Photo(cashIcon, color: textSecondaryColor),
//           activeIcon: Photo(cashIcon, color: primaryColor),
//           label: 'Earning',
//         ),
//         BottomNavigationBarItem(
//           icon: Photo(userIcon, color: textSecondaryColor),
//           activeIcon: Photo(userIcon, color: primaryColor),
//           label: 'Profile',
//         ),
//       ],
//     );
//   }
// }
