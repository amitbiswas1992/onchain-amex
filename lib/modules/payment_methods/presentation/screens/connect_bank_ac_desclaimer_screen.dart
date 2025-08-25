import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/containers/icon_outer_circle.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../core/widgets/texts/title_text.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../rewards/presentation/screens/rewards_strings.dart';
import '../providers/payment_method_providers.dart';

class ConnectBankAcDisclaimerScreen extends ConsumerStatefulWidget {
  const ConnectBankAcDisclaimerScreen({super.key});

  @override
  ConsumerState createState() => _ConnectBankAcDisclaimerScreenState();
}

class _ConnectBankAcDisclaimerScreenState extends ConsumerState<ConnectBankAcDisclaimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const VerticalSpace(AppValues.paddingLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconOuterCircle(
                        icon: SvgPicture.asset(
                          'assets/icons/bank.svg',
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(-10, 0), // adjust overlap
                        child: IconOuterCircle(
                          icon: SvgPicture.asset(
                            'assets/icons/plaid.svg',
                            color: Theme.of(context).iconTheme.color,
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(32),
                  const TitleText(
                    text: 'Connect your B.D. bank\naccount to Amex',
                    textAlign: TextAlign.center,
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  Text(
                    "Connecting with Plaid is secure and you can keep using your accounts for future payments.\nIt also helps us to verify that you always have enough balance for every transaction.",
                    textAlign: TextAlign.center,
                    style: s14W400(context),
                  ),
                  const VerticalSpace(32),
                  ...[
                    {'name': 'Verify less than a minute', 'icon': 'check.svg'},
                    {'name': 'Remove the connection anytime', 'icon': 'gear.svg'},
                    {
                      'name': 'Use the same account later when you pay for your repayment',
                      'icon': 'bank.svg'
                    },
                  ].map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppValues.paddingSmall,
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/${e['icon'] ?? ''}',
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const HorizontalSpace(AppValues.paddingSmall),
                            Expanded(
                              child: Text(
                                e['name'] ?? '',
                                style: s14W600(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            SafeArea(
              child: AppPrimaryButton(
                title: startVerification,
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
