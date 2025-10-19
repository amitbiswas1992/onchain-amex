import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/title_and_widget.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../resources/cards_strings.dart';

class ChooseCardInfoInputScreen extends ConsumerStatefulWidget {
  const ChooseCardInfoInputScreen({super.key});

  @override
  ConsumerState createState() => _ChooseCardInformationInputScreenState();
}

class _ChooseCardInformationInputScreenState extends ConsumerState<ChooseCardInfoInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppValues.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cardInformation, style: s18W600(context),),
              const VerticalSpace(AppValues.paddingMedium),
              Text(
                allTheInformationHasBeenFilledUp,
                style: s12W400(context),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const TitleAndWidget(
                titleText: 'Name on the card',
                subTitle: ' (Optional)',
                widget: AppTextFormField(
                  hintText: 'Name',
                ),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const TitleAndWidget(
                titleText: 'Country of residence',
                widget: AppTextFormField(
                  hintText: 'Country',
                ),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const TitleAndWidget(
                titleText: 'Full legal name',
                widget: AppTextFormField(
                  hintText: 'Full legal name',
                ),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const TitleAndWidget(
                titleText: 'Date of birth',
                widget: AppTextFormField(
                  hintText: '27/07/1996',
                ),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const TitleAndWidget(
                titleText: 'Phone number',
                widget: AppTextFormField(
                  hintText: '01827504142',
                ),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const TitleAndWidget(
                titleText: 'Home Address',
                widget: AppTextFormField(
                  hintText: 'House 09, Road 02, Section C, Mirpur',
                ),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const TitleAndWidget(
                titleText: 'City',
                widget: AppTextFormField(
                  hintText: 'Dhaka',
                ),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const TitleAndWidget(
                titleText: 'Zip Code',
                widget: AppTextFormField(
                  hintText: '000',
                ),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              const TitleAndWidget(
                titleText: 'Nationality',
                widget: AppTextFormField(
                  hintText: 'Bangladeshi',
                ),
              ),
              const VerticalSpace(32),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'By continuing, you confirm this information is correct.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9),
                ),
              ),
              const VerticalSpace(AppValues.paddingSmall + 4),
              AppPrimaryButton(
                title: 'Confirm & Pay 5 USD',
                onTap: () {
                  AppNav.goRouter.push(RtNm.orderCardPaymentMethodScreen);
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
