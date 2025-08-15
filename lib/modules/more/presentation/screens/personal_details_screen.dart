import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../widgets/menu_section.dart';

class PersonalDetailsScreen extends ConsumerWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MenuSection(
              title: 'Personal Details',
              items: [
                MenuItem(
                  icon: 'assets/icons/person.svg',
                  title: 'Personal Information',
                  subtitle: 'Manage your personal information',
                  onTap: () {
                    AppNav.goRouter.push(RtNm.personalInformationScreen);
                  },
                ),
                MenuItem(
                  icon: 'assets/icons/email.svg',
                  title: 'Email address',
                  subtitle: 'mtoshakir@gmail.com (Verified)',
                  onTap: () {
                    AppNav.goRouter.push(RtNm.changeEmailScreen);
                  },
                ),
                MenuItem(
                  icon: 'assets/icons/phone.svg',
                  title: 'Phone number',
                  subtitle: '+8801790300838',
                  onTap: () {
                    AppNav.goRouter.push(RtNm.changePhoneScreen);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
