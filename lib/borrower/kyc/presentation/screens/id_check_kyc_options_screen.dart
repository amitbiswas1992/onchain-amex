import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_picker_button.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../more/presentation/providers/more_providers.dart';
import '../controllers/kyc_controller.dart';
import '../providers/kyc_providers.dart';

class IdCheckKycOptionsScreen extends ConsumerStatefulWidget {
  const IdCheckKycOptionsScreen({super.key});

  @override
  ConsumerState createState() => _IdCheckKycOptionsScreenState();
}

class _IdCheckKycOptionsScreenState extends ConsumerState<IdCheckKycOptionsScreen> {

  late final KycController _controller;

  @override
  void initState() {
    _controller = KycController(
      context: context,
      ref: ref,
      kycRepo: ref.read(kycRepo),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose issuing country/region',
                  style: s18W600(context),
                ),
                const VerticalSpace(AppValues.paddingMedium),
                Consumer(builder: (context, ref, _) {
                  final selected = ref.watch(selectedCountryProvider);

                  return AppPickerButton(
                    hint: 'Country',
                    value: selected?.name,
                    onTap: () async {
                      showCountryPicker(
                        context: context,
                        onSelect: (c) {
                          ref.read(selectedCountryProvider.notifier).state = c;
                        },
                      );
                    },
                    icon: const Icon(Icons.arrow_drop_down_sharp),
                  );
                },),
                const VerticalSpace(AppValues.paddingLarge * 2),
                Text(
                  'Select ID type',
                  style: s18W600(context),
                ),
                const VerticalSpace(AppValues.paddingSmall),
                const Text('Use a valid government-issued photo ID'),
                const VerticalSpace(AppValues.paddingMedium),
                _button(
                  title: 'Passport',
                  icon: const Icon(
                    CupertinoIcons.globe,
                    color: Colors.white,
                  ),
                  onTap: () {
                    _captureImage();
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),
                _button(
                  title: "Driver's License",
                  icon: const Icon(
                    CupertinoIcons.car_detailed,
                    color: Colors.white,
                  ),
                  onTap: () {
                    _captureImage();
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),
                _button(
                  title: 'Passport',
                  icon: const Icon(
                    CupertinoIcons.person_crop_rectangle_fill,
                    color: Colors.white,
                  ),
                  onTap: () {
                    _captureImage();
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),
                const Text('Have you checked if your ID supported?'),
                const VerticalSpace(AppValues.paddingLarge * 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _captureImage() async {
    final xFile = await ImagePicker().pickImage(imageQuality: 50, source: ImageSource.camera);
    if (xFile == null) {
      showWarningDialog(
        context: context,
        message: 'Please capture your valid document image to complete the KYC',
      );
    }
    if (xFile != null) {
      _controller.updateKycStatus();
    }
  }

  Widget _button({
    required String title,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingSmall,
          vertical: AppValues.paddingSmall,
        ),
        decoration: const BoxDecoration(
          color: AppColors.primaryLight,
        ),
        child: Row(
          children: [
            icon,
            const HorizontalSpace(AppValues.paddingSmall),
            Text(title, style: s18W600(context).copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
