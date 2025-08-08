import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../resources/signin_strings.dart';
import '../widgets/amex_text_app_bar.dart';

class UserInfoInputScreen extends ConsumerStatefulWidget {
  const UserInfoInputScreen({super.key});

  @override
  ConsumerState createState() => _UserInfoInputScreenState();
}

class _UserInfoInputScreenState extends ConsumerState<UserInfoInputScreen> {

  final _firstNameNode = FocusNode();
  final _lastNameNode = FocusNode();
  String _firstName = '';
  String _lastName = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.paddingMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AmexTextAppBar(),
              const VerticalSpace(68),
              const TitleText(
                text: SignInStrings.whatShouldICallYou,
                textAlign: TextAlign.start,
              ),
              const VerticalSpace(AppValues.paddingMedium),
              Text(
                SignInStrings.enterYourNameWeWillCompleteKYClater,
                style: s14W400(context),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              AppTextFormField(
                focusNode: _firstNameNode,
                hintText: SignInStrings.firstName,
              ),
              const VerticalSpace(AppValues.paddingMedium),
              AppTextFormField(
                focusNode: _lastNameNode,
                hintText: SignInStrings.lastName,
              ),
              const Expanded(child: SizedBox()),
              SafeArea(
                child: AppPrimaryButton(
                  title: SignInStrings.continuee,
                  onTap: () {
                    unFocus(context);
                    AppNav.goRouter.push(RtNm.inviteFriendScreen);
                  },
                ),
              ),
              const VerticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }
}
