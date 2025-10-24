import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../rewards/presentation/screens/rewards_strings.dart';
import '../providers/more_providers.dart';
import 'security_privacy_screen.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.paddingMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpace(24),
              Text(notificationSettings, style: s18W600(context),),
              const VerticalSpace(AppValues.paddingLarge),
              Consumer(
                builder: (context, ref, _) {

                  final enabled = ref.watch(notificationEnabledProvider);

                  return BiometricToggleMenuItem(
                    enabled: enabled,
                    onToggle: (val) {
                      ref.read(notificationEnabledProvider.notifier).state = val;
                    },
                    assetPath: 'assets/icons/bell.svg',
                    title: pushNotification,
                    subTitle: 'Receive alerts and updates',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
