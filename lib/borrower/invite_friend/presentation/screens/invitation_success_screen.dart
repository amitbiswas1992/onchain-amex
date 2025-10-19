import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/image_title_subtitle_button.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../signin/presentation/resources/signin_strings.dart';
import '../resources/invite_strings.dart';

class InvitationSuccessScreen extends ConsumerStatefulWidget {
  const InvitationSuccessScreen({super.key});

  @override
  ConsumerState createState() => _InvitationSuccessScreenState();
}

class _InvitationSuccessScreenState extends ConsumerState<InvitationSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMedium,
        ),
        child: ImageTitleSubtitleButton(
          assetPath: 'assets/images/invitation_success.png',
          title: congratulations,
          subTitle: willBeAddedToYourAccountShortly,
          buttonTitle: continuee,
          onButtonTap: () {
            AppNav.goRouter.go(RtNm.spendScreen);
          },
        ),
      ),
    );
  }
}
