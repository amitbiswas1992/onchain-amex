import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/errors/when_error_widget.dart';
import '../../../../core/widgets/loaders/when_loading_widget.dart';
import '../../../../infrastructure/network/result.dart';
import '../../data/models/device_session.dart';
import '../controllers/devices_controller.dart';
import '../providers/more_providers.dart';

class ManageDevicesScreen extends ConsumerStatefulWidget {
  const ManageDevicesScreen({super.key});

  @override
  ConsumerState createState() => _ManageDevicesScreenState();
}

class _ManageDevicesScreenState extends ConsumerState<ManageDevicesScreen> {

  late final DevicesController _controller;

  @override
  void initState() {
    _controller = DevicesController(context: context, ref: ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final asyncDeviceSessions = ref.watch(deviceSessionsProvider);
    final asyncFingerprint = ref.watch(deviceFingerprintProvider);

    return Scaffold(
      appBar: const PrimaryAppBar(),
      body: asyncFingerprint.when(
        data: (fingerPrint) {
          return asyncDeviceSessions.when(
            data: (result) {
              switch (result) {
                case Ok<List<DeviceSession>?>():
                  final deviceSessions = result.data ?? [];
                  if (deviceSessions.isEmpty) {
                    return const Center(
                      child: Text('No other devices has linked to this account.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: deviceSessions.length,
                    padding: const EdgeInsets.all(AppValues.paddingMedium),
                    itemBuilder: (context, index) {
                      final session = deviceSessions[index];
                      final platform = (session.device?.platform ?? '').toLowerCase();
                      return ListTile(
                        leading: platform == 'ios'
                            ? const Icon(Icons.apple)
                            : platform == 'android'
                                ? const Icon(Icons.android)
                                : const Icon(Icons.web),
                        title: Text(session.device?.deviceName ?? ''),
                        subtitle: Text(session.device?.deviceType ?? ''),
                        trailing: Visibility(
                          visible: fingerPrint != session.deviceId,
                          child: InkResponse(
                            onTap: () {
                              _controller.deleteDeviceSession(session: session);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: AppColors.errorLight,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                case Error<List<DeviceSession>?>():
                  return WhenErrorWidget(message: result.toString());
              }
            },
            error: (error, stck) => const WhenErrorWidget(),
            loading: () => const WhenLoadingWidget(),
          );
        },
        error: (error, stck) => WhenErrorWidget(error: error),
        loading: () => const WhenLoadingWidget(),
      ),
    );
  }
}