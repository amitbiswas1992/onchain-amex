import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/dialogs.dart';
import '../../../../infrastructure/di/global_providers.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/api_urls.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../more/data/models/profile.dart';

class DeleteAccountController {
  final BuildContext context;
  final WidgetRef ref;

  const DeleteAccountController({required this.context, required this.ref});

  Future<void> deleteAccount({required Profile profile}) async {
    try {
      final response = await ref.read(dioService).delete(ApiUrls.deleteUser(profile.id ?? ''));
      final result = response.toResult(dataHandler: (json) {});
      switch (result) {
        case Ok<Null>():
          showSuccessDialog(
            context: context,
            message: result.message,
            dismissible: false,
            onDone: () async {
              await ref.read(securedStorageService).deleteUserTokens();
              AppNav.goRouter.go(RtNm.splashScreen);
            },
          );
        case Error<Null>():
          showErrorDialog(context: context, message: result.toString());
      }
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      showErrorDialog(context: context, message: error.toString());
    }
  }
}
