import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/invitation_success.png',
            ),
            const SizedBox(height: AppValues.paddingSmall),
            const TitleText(
              text: InviteStrings.congratulations,
            ),
            const VerticalSpace(AppValues.paddingMedium),
            Text(
              InviteStrings.willBeAddedToYourAccountShortly,
              style: s14W400(context),
            ),
            const VerticalSpace(32),
            AppPrimaryButton(
              title: SignInStrings.continuee,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
