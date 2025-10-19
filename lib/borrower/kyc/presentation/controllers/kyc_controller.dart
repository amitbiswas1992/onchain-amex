import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/dialogs.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/navigation/rt_nm.dart';
import '../../../../infrastructure/network/result.dart';
import '../../../more/presentation/providers/more_providers.dart';
import '../../business/repository/kyc_repo_interface.dart';

class KycController {
  final BuildContext context;
  final WidgetRef ref;
  final KycRepoInterface kycRepo;

  const KycController({required this.context, required this.ref, required this.kycRepo});

  Future<void> updateKycStatus() async {
    showLoadingDialog(context: context, message: 'Verifying your document...');
    final result = await kycRepo.updateKycStatus(
      payload: {
        "status": "VERIFIED",
        "reason": "Document verification successful",
      },
    );
    hideDialog();

    switch (result) {
      case Ok():
        AppNav.goRouter.push(RtNm.kycSuccessScreen);
        ref.invalidate(profileProvider);
      case Error():
        showErrorDialog(context: context, message: result.toString());
    }
  }
}
