import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../resources/invite_strings.dart';

class InviteFriendScreen extends ConsumerStatefulWidget {
  const InviteFriendScreen({super.key});

  @override
  ConsumerState createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends ConsumerState<InviteFriendScreen> {
  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

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
              VerticalSpace(padding.top),
              const VerticalSpace(AppValues.paddingLarge),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    AppNav.goRouter.push(RtNm.inviteCodeInputScreen);
                  },
                  child: Container(
                    height: 24,
                    alignment: Alignment.centerRight,
                    child: Text(
                      InviteStrings.haveAnInvitation,
                      style: s14W500(
                        context,
                        fontFamily: interFontFamily,
                      ).copyWith(
                        color: AppColors.primaryLight,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primaryLight,
                      ),
                    ),
                  ),
                ),
              ),
              const VerticalSpace(16),
              SvgPicture.asset(
                'assets/icons/people.svg',
                height: 44,
                width: 44,
              ),
              const VerticalSpace(16),
              const TitleText(text: InviteStrings.inviteYourFriendAndGet),
              const VerticalSpace(AppValues.paddingMedium),
              Text(
                InviteStrings.alternativelyYouCanUseYour,
                style: s14W400(context),
              ),
              const VerticalSpace(AppValues.paddingSmall),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.jungleGreen.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.paddingMedium - 4,
                  vertical: AppValues.paddingSmall,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SHAIF006',
                      style: s14W500(context).copyWith(
                        color: AppColors.jungleGreen,
                      ),
                    ),
                    const HorizontalSpace(AppValues.paddingSmall),
                    const SizedBox(
                      height: 16,
                      width: 16,
                      child: Icon(
                        Icons.copy,
                        color: AppColors.jungleGreen,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              AppPrimaryButton(
                title: InviteStrings.shareLink,
                onTap: () {
                  AppNav.goRouter.push(RtNm.inviteCodeInputScreen);
                },
              ),
              const VerticalSpace(20),
              AppSecondaryButton(
                title: InviteStrings.skip,
                onTap: () {
                  AppNav.goRouter.push(RtNm.inviteCodeInputScreen);
                },
              ),
              const VerticalSpace(AppValues.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }
}
