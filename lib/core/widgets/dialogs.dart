import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/navigation/app_nav.dart';
import '../resources/app_colors.dart';
import '../resources/app_values.dart';
import '../utils/sizebox_util.dart';
import 'buttons/app_button.dart';
import 'texts/title_text.dart';

Future<void> showSuccessDialog({
  required BuildContext context,
  required String message,
  Function()? onDone,
  bool dismissible = false,
}) async {
  return statusDialogBase(
    context: context,
    title: 'Success!',
    message: message,
    icon: SvgPicture.asset('assets/icons/check_circle_green.svg'),
    onDone: onDone,
    dismissible: dismissible,
  );
}

Future<void> showWarningDialog({
  required BuildContext context,
  required String message,
  Function()? onDone,
  bool dismissible = false,
}) async {
  return statusDialogBase(
    context: context,
    title: 'Warning!',
    message: message,
    icon: Image.asset('assets/icons/warning.png'),
    onDone: onDone,
    dismissible: dismissible,
  );
}

Future<void> showErrorDialog({
  required BuildContext context,
  required String message,
  Function()? onDone,
  bool dismissible = false,
}) async {
  return statusDialogBase(
    context: context,
    title: 'Error!',
    message: message,
    icon: SvgPicture.asset('assets/icons/error_circle.svg'),
    onDone: onDone,
    dismissible: dismissible,
  );
}

Future<void> statusDialogBase({
  required BuildContext context,
  required String title,
  required String message,
  required Widget icon,
  Function()? onDone,
  bool dismissible = false,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingLarge + AppValues.paddingSmall,
          // vertical: MediaQuery.of(context).size.height * .29,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.borderRadiusLarge),
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: AppColors.whiteSmoke,
            borderRadius: BorderRadius.circular(AppValues.borderRadiusLarge),
          ),
          padding: const EdgeInsets.all(
            AppValues.paddingLarge + AppValues.paddingSmall,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon,
                  const VerticalSpace(AppValues.paddingSmall),
                  TitleText(
                    text: title,
                    color: AppColors.primaryLight,
                    textAlign: TextAlign.center,
                  ),
                  const VerticalSpace(AppValues.paddingMedium),
                  SingleChildScrollView(
                    child: SubTitleText(
                      text: message,
                      color: Colors.black54,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const VerticalSpace(AppValues.paddingLarge + AppValues.paddingMedium),
              AppButton(
                title: 'Done',
                color: AppColors.primaryLight,
                verticalPadding: AppValues.paddingMedium - 4,
                radius: 15,
                titleStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                onTap: () {
                  onDone?.call();
                  AppNav.goRouter.pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<bool> showPermissionDialog({
  required BuildContext context,
  String? title,
  required String message,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppValues.paddingLarge + AppValues.paddingMedium,
          vertical: MediaQuery.of(context).size.height * .35,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.borderRadiusLarge - 5),
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: AppColors.whiteSmoke,
            borderRadius: BorderRadius.circular(AppValues.borderRadiusLarge),
          ),
          padding: const EdgeInsets.all(AppValues.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: title != null,
                    child: Text(
                      title ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                  const VerticalSpace(AppValues.paddingSmall),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      title: 'Cancel',
                      // color: AppColors.yellowGreen,
                      verticalPadding: AppValues.paddingMedium - 4,
                      radius: 15,
                      titleStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLight,
                      ),
                      onTap: () {
                        AppNav.goRouter.pop(false);
                      },
                    ),
                  ),
                  const HorizontalSpace(AppValues.paddingSmall),
                  Expanded(
                    child: AppButton(
                      title: 'Yes',
                      color: AppColors.primaryLight,
                      verticalPadding: AppValues.paddingMedium - 4,
                      radius: 15,
                      titleStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        // color: AppColors.yellowGreen,
                      ),
                      onTap: () async {
                        AppNav.goRouter.pop(true);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showLoadingDialog({
  required BuildContext context,
  String? message,
  bool dismissible = false,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppValues.paddingLarge,
          vertical: MediaQuery.of(context).size.height * .35,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.borderRadiusMedium),
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: AppColors.whiteSmoke,
            borderRadius: BorderRadius.circular(AppValues.borderRadiusLarge),
          ),
          padding: const EdgeInsets.all(AppValues.paddingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SpinKitFadingCircle(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      );
                    },
                  ),
                  const HorizontalSpace(AppValues.paddingMedium),
                  Expanded(
                    child: Text(
                      message ?? 'Loading...',
                      style: const TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void hideDialog() => AppNav.goRouter.pop();
