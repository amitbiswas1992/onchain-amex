import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/dialogs.dart';
import '../../../../infrastructure/network/result.dart';
import '../../data/models/device_session.dart';
import '../providers/more_providers.dart';

class DevicesController {
  final BuildContext context;
  final WidgetRef ref;

  const DevicesController({required this.context, required this.ref});

  Future<void> deleteDeviceSession({required DeviceSession session}) async {

    final delete = await showPermissionDialog(context: context, message: 'Are you sure?');

    if (delete != true) return;

    showLoadingDialog(context: context, message: 'Deleting device session...');
    final result = await ref.read(devicesRepo).deleteDeviceSession(deviceID: session.deviceId ?? '');
    hideDialog();
    switch (result) {
      case Ok():
        showSuccessDialog(context: context, message: 'Device session deleted successfully');
        ref.invalidate(deviceSessionsProvider);
      case Error():
        showErrorDialog(context: context, message: 'Something went wrong. Please try again later.');
    }
  }
}
