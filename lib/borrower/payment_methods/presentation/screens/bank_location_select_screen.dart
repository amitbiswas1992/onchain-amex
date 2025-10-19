import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/info.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';

class BankLocationSelectScreen extends ConsumerStatefulWidget {
  const BankLocationSelectScreen({super.key});

  @override
  ConsumerState createState() => _BankLocationSelectScreenState();
}

class _BankLocationSelectScreenState extends ConsumerState<BankLocationSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppValues.paddingMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalSpace(AppValues.paddingSmall),
              Text(
                'Bank account location',
                style: s18W600(context),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              Text(
                'Please select the country in which your bank account is located. We currently support countries from the list below.',
                style: s12W400(context),
              ),
              const VerticalSpace(AppValues.paddingMedium),
              ...[
                {'name': 'Australia', 'icon' :'australia.svg'},
                {'name': 'Bangladesh', 'icon' :'bangladesh.svg'},
                {'name': 'Canada', 'icon' :'canada.svg'},
                {'name': 'United Kingdom', 'icon' :'united_kingdom.svg'},
                {'name': 'United States', 'icon' :'united_states.svg'},
              ].map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppValues.paddingSmall,
                  ),
                  child: InkWell(
                    onTap: () {
                      AppNav.goRouter.pushReplacement(RtNm.connectBankAcDisclaimerScreen);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/country_flags/${e['icon'] ?? ''}'),
                        const HorizontalSpace(AppValues.paddingSmall),
                        Expanded(child: Text(e['name'] ?? '', style: s14W600(context),),),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.c455468,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const VerticalSpace(AppValues.paddingMedium),
              const Info(content: 'Other countries outside the list are not supported currently'),
            ],
          ),
        ),
      ),
    );
  }
}
