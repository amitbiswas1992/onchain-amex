import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:reown_appkit/reown_appkit.dart';

import '../../../../core/resources/app_secrets.dart';

class AppKitModelProvider {
  ReownAppKitModal getAppKitModel({
    required BuildContext context,
    required String iosRedirectScreen,
  }) {
    return ReownAppKitModal(
      context: context,
      projectId: reownProjectId,
      logLevel: LogLevel.all,
      metadata: PairingMetadata(
        name: 'TMRW',
        description: 'TMRW App',
        redirect: Redirect(
          native: Platform.isIOS ? 'tmrw://$iosRedirectScreen' : 'tmrw://',
          linkMode: false,
        ),
      ),
    );
  }
}
