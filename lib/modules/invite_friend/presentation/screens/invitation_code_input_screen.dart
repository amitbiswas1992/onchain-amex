import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../signin/presentation/resources/signin_strings.dart';
import '../resources/invite_strings.dart';

class InvitationCodeInputScreen extends ConsumerStatefulWidget {
  const InvitationCodeInputScreen({super.key});

  @override
  ConsumerState createState() => _InviteCodeInputScreenState();
}

class _InviteCodeInputScreenState extends ConsumerState<InvitationCodeInputScreen> {

  final _formKey = GlobalKey<FormState>();
  final _codeNode = FocusNode();
  String _code = '';

  @override
  void dispose() {
    _codeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: const PrimaryAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.paddingMedium,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpace(20),
                const TitleText(
                  text: InviteStrings.enterTheValidationCode,
                ),
                const VerticalSpace(AppValues.paddingMedium),
                Text(
                  InviteStrings.youWillGetAsInvitationGift,
                  style: s14W400(context),
                ),
                const VerticalSpace(AppValues.paddingMedium),
                AppTextFormField(
                  focusNode: _codeNode,
                  hintText: InviteStrings.invitationCode,
                ),
                const Expanded(child: SizedBox()),
                AppPrimaryButton(title: SignInStrings.continuee, onTap: () {
                  AppNav.goRouter.push(RtNm.invitationSuccessScreen);
                },),
                const VerticalSpace(AppValues.paddingLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
