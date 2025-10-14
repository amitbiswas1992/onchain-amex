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
import '../../../../core/widgets/containers/app_chip.dart';
import '../../../../core/widgets/containers/deem_card.dart';
import '../../../../core/widgets/containers/icon_outer_circle.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../data/models/payment_success_extra.dart';
import '../providers/spend_providers.dart';
import '../resources/spends_strings.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState createState() => _SpendAfterScanAmountInputScreenState();
}

class _SpendAfterScanAmountInputScreenState extends ConsumerState<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: const PrimaryAppBar(),
        body: Padding(
          padding: const EdgeInsetsGeometry.all(AppValues.paddingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DeemCard(
                        padding: const EdgeInsets.all(AppValues.paddingMedium),
                        child: Row(
                          children: [
                            Text(
                              to,
                              style: s14W500(context),
                            ),
                            const HorizontalSpace(12),
                            IconOuterCircle(
                              size: 40,
                              icon: SvgPicture.asset(
                                'assets/icons/shopping_bag.svg',
                                height: 24,
                                width: 24,
                              ),
                            ),
                            const HorizontalSpace(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SubTitleText(text: 'Starbucks'),
                                  const VerticalSpace(AppValues.paddingSmall),
                                  Text(
                                    '0123....................................3456',
                                    style: s11W600(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalSpace(32),
                      const SubTitleText(text: enterAmount),
                      const VerticalSpace(24),
                      TextFormField(
                        style: s54w600(context),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '0.0',
                          hintStyle: s54w600(context).copyWith(color: AppColors.c757575),
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: AppValues.paddingMedium,
                            horizontal: AppValues.paddingMedium,
                          ),
                        ),
                        onChanged: (val) {
                          ref.read(inputDetectorProvider.notifier).state = val ?? '';
                        },
                      ),
                      const VerticalSpace(12),
                      const Align(
                        alignment: Alignment.center,
                        child: AppChip(
                          text: max,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final input = ref.watch(inputDetectorProvider);

                      if (input.isEmpty) {
                        return AppSecondaryButton(
                          title: makePayment,
                          rounded: false,
                          showBorder: false,
                          deepColor: false,
                          titleColor: AppColors.surfaceLight,
                          onTap: () {},
                        );
                      }

                      return AppPrimaryButton(
                        title: makePayment,
                        onTap: () {
                          AppNav.goRouter.push(
                            RtNm.paymentSuccessScreen,
                            extra: PaymentSuccessExtra.dummay(),
                          );
                        },
                      );
                    },
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
