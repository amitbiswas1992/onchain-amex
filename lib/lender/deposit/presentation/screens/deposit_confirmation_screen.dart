import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';

class DepositConfirmationScreen extends StatefulWidget {
  const DepositConfirmationScreen({super.key});

  @override
  State<DepositConfirmationScreen> createState() =>
      _DepositConfirmationScreenState();
}

class _DepositConfirmationScreenState extends State<DepositConfirmationScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _codeController.addListener(() {
      if (_codeController.text.length >= 6) {
        // _codeController.text = _codeController.text.substring(0, 6);
        // _codeController.selection = TextSelection.fromPosition(
        //   TextPosition(offset: _codeController.text.length),
        // );

        setState(() {}); // Update the UI when the text changes
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => AppNav.goRouter.pop(),
        ),
        title: Text('Deposit', style: s18W600(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppValues.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalSpace(40),
            Text(
              'Enter the code',
              style: s24W500(context),
              textAlign: TextAlign.center,
            ),
            const VerticalSpace(16),
            Text(
              "We've sent a code to intoshakar@gmail.com",
              style: s14W400(context).copyWith(color: AppColors.c757575),
              textAlign: TextAlign.center,
            ),
            const VerticalSpace(40),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _codeController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.c455468.withValues(alpha: 0.3),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                hintText: 'Confirmation Code',
                hintStyle: const TextStyle(
                  color: AppColors.c757575,
                  fontSize: 16,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              style: s20W500(context),
            ),
            const Spacer(),
            AppPrimaryButton(
              title: 'Continue',
              isExpanded: true,
              onTap: _codeController.text.length == 6
                  ? () {
                      HapticFeedback.lightImpact();
                      AppNav.goRouter.push(RtNm.successScreen);
                    }
                  : null,
            ),
            const VerticalSpace(40),
          ],
        ),
      ),
    );
  }
}
