import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';

class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});

  @override
  ConsumerState createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.paddingMedium,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Start verification',
                  style: s28W600(context),
                ),
                const VerticalSpace(AppValues.paddingLarge * 3),
                const Text(
                  'This process is designed to verify your\nidentity and protect you from identity theft',
                  textAlign: TextAlign.center,
                ),
                const VerticalSpace(AppValues.paddingMedium),
                const Text(
                  "Please have your ID ready and click 'Start:",
                  textAlign: TextAlign.center,
                ),
                const VerticalSpace(
                    AppValues.paddingLarge + AppValues.paddingMedium,),
                AppPrimaryButton(
                  title: 'Start',
                  titleStyle: s22W600(context).copyWith(color: Colors.white),
                  onTap: () {
                    AppNav.goRouter.push(RtNm.idCheckKycOptionsScreen);
                  },
                ),
                const VerticalSpace(AppValues.paddingLarge),
                const Text(
                  """By clicking "Start" you consent to Soho Pay collecting your data pursuant to its Privacy Policy""",
                  textAlign: TextAlign.center,
                ),
                const VerticalSpace(AppValues.paddingLarge * 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
