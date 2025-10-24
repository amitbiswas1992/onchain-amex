import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/buttons/app_secondary_button.dart';
import '../../../../core/widgets/buttons/app_text_utton.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../splash/presentation/providers/onboard_providers.dart';
import '../../../splash/presentation/resources/onboard_strings.dart';
import '../../../splash/presentation/widgets/onboard_content.dart';

class OnboardScreen extends ConsumerStatefulWidget {
  const OnboardScreen({super.key});

  @override
  ConsumerState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends ConsumerState<OnboardScreen> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const VerticalSpace(10),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: AppTextButton(
                  text: 'SKIP',
                  textStyle: s14W600(context),
                  onPressed: () {
                    ref.read(securedStorageService).markAsOnboarded();
                    AppNav.goRouter.go(RtNm.registerWithEmailScreen);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  ref.read(onboardPageProvider.notifier).state = page;
                },
                children: const [
                  OnboardContent(
                    assetPath: 'assets/images/onboard/onboard1.png',
                    title: getInstantCredit,
                    description: getUsdtCreditInSecond,
                  ),
                  OnboardContent(
                    assetPath: 'assets/images/onboard/onboard2.png',
                    title: decentralized,
                    description: noBankJustSmartContracts,
                  ),
                  OnboardContent(
                    assetPath: 'assets/images/onboard/onboard3.png',
                    title: yourWallet,
                    description: connectAnyWeb3Wallet,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: SlideEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  dotColor: const Color(0xFF0F111F).withValues(alpha: .2),
                  activeDotColor: AppColors.primaryLight,
                ),
              ),
            ),
            Row(
              children: [
                const HorizontalSpace(AppValues.paddingMedium),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final page = ref.watch(onboardPageProvider);

                      if (page == 2) {
                        return AppPrimaryButton(
                          title: getStarted,
                          onTap: () {
                            ref.read(securedStorageService).markAsOnboarded();
                            AppNav.goRouter.go(RtNm.registerWithEmailScreen);
                          },
                        );
                      }

                      return AppSecondaryButton(
                        title: next,
                        radius: 10,
                        rounded: false,
                        showBorder: true,
                        onTap: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      );
                    },
                  ),
                ),
                const HorizontalSpace(AppValues.paddingMedium),
              ],
            ),
            const VerticalSpace(AppValues.paddingMedium),
          ],
        ),
      ),
    );
  }
}
