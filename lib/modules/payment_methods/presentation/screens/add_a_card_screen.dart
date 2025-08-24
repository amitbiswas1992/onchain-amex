import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/title_and_widget.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../cards/presentation/providers/card_providers.dart';
import '../../../rewards/presentation/screens/rewards_strings.dart';
import '../providers/payment_method_providers.dart';

class AddACardScreen extends ConsumerStatefulWidget {
  const AddACardScreen({super.key});

  @override
  ConsumerState createState() => _AddACardScreenState();
}

class _AddACardScreenState extends ConsumerState<AddACardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpace(24),
                    Text(
                      addANewCard,
                      style: s18W600(context),
                    ),
                    const VerticalSpace(AppValues.paddingMedium),
                    Text(
                      'We accept Visa, Mastercard and Maestro.',
                      style: s12W400(context),
                    ),
                    const VerticalSpace(AppValues.paddingMedium),
                    const TitleAndWidget(
                      titleText: cardNumber,
                      widget: AppTextFormField(
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const VerticalSpace(AppValues.paddingMedium),
                    const Row(
                      children: [
                        Expanded(
                          child: TitleAndWidget(
                            titleText: 'Expiry (MM/YY)',
                            widget: AppTextFormField(
                              hintText: '',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                            ),
                          ),
                        ),
                        HorizontalSpace(AppValues.paddingMedium),
                        Expanded(
                          child: TitleAndWidget(
                            titleText: 'CVV/CVC',
                            widget: AppTextFormField(
                              hintText: '',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icon(Icons.credit_card),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                'By continuing, system will do a check if the card is valid.',
                style: s11W400(context),
                textAlign: TextAlign.center,
              ),
            ),
            const VerticalSpace(AppValues.paddingMedium),
            SafeArea(
              child: AppPrimaryButton(
                title: addCard,
                onTap: () {
                  ref.read(cardSavedProvider.notifier).state = true;
                  AppNav.goRouter.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
