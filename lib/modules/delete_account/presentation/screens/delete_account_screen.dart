import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../providers/delete_account_providers.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppValues.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/icons/mice.png'),
                const VerticalSpace(AppValues.paddingMedium),
                const TitleText(
                  text: 'Are you sure you want to close your account?',
                  textAlign: TextAlign.center,
                ),
                const VerticalSpace(AppValues.paddingMedium),
                Text(
                  'Type ‘DELETE’ in the input box to confirm',
                  style: s14W400(context),
                ),
                const VerticalSpace(44),
                AppTextFormField(
                  onChanged: (val) {
                    if (val == 'DELETE') {
                      ref.read(deleteAccountButtonEnabledProvider.notifier).state = true;
                    } else {
                      ref.read(deleteAccountButtonEnabledProvider.notifier).state = false;
                    }
                  },
                ),
                const VerticalSpace(32),
                Consumer(
                  builder: (context, ref, _) {
                    final enabled = ref.watch(deleteAccountButtonEnabledProvider);

                    return AppPrimaryButton(
                      title: 'Close and delete my account',
                      color: enabled
                          ? const Color(0xFFFF3838)
                          : const Color(0xFFE92215).withValues(alpha: .16),
                      onTap: () {
                        if (enabled) {
                          AppNav.goRouter.pop();
                        } else {}
                      },
                    );
                  },
                ),
                const VerticalSpace(AppValues.paddingLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
