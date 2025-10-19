import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/image_title_subtitle_button.dart';
import '../../../../infrastructure/navigation/app_nav.dart';

class KycSuccessScreen extends StatefulWidget {
  const KycSuccessScreen({super.key});

  @override
  State<KycSuccessScreen> createState() => _KycSuccessScreenState();
}

class _KycSuccessScreenState extends State<KycSuccessScreen> {
  bool _loading = true;



  void _stopLoading() async {
    await Future.delayed(const Duration(seconds: 6));
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {

    _stopLoading();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const PrimaryAppBar(),
      body: _loading ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitChasingDots(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(100),
                  ),
                );
              },
            ),
            const VerticalSpace(AppValues.paddingMedium),
            const Text('We are verifying your identity...'),
          ],
        ),
      ) : Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMedium,
        ),
        child: ImageTitleSubtitleButton(
          assetPath: 'assets/icons/success.svg',
          title: 'Successful',
          subTitle: 'Your KYC has been successful.',
          buttonTitle: 'Done',
          onButtonTap: () {
            AppNav.goRouter.pop();
            AppNav.goRouter.pop();
            AppNav.goRouter.pop();
          },
        ),
      ),
    );
  }
}
