import '../../../../core/utils/log_util.dart';
import '../../../../infrastructure/network/api_urls.dart';
import '../../../../infrastructure/network/dio_service.dart';
import '../../../../infrastructure/network/result.dart';
import '../../business/repository/devices_repo_interface.dart';
import '../models/device_session.dart';

class DevicesRepo implements DevicesRepoInterface {
  final DioService dioService;

  DevicesRepo({required this.dioService});

  @override
  Future<Result<List<DeviceSession>?>> getSignedDevices() async {
    try {
      return (await dioService.get(ApiUrls.deviceSessions, useTokenizeHeader: true)).toResult(
        dataHandler: (json) {
          return (json as List).map((e) => DeviceSession.fromJson(e)).toList();
        },
      );
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }

  @override
  Future<Result> deleteDeviceSession({required String deviceID}) async {
    try {
      return (await dioService.delete(ApiUrls.deleteDeviceSession(deviceID),
              useTokenizeHeader: true))
          .toResult(
        dataHandler: null,
      );
    } catch (error, stck) {
      return handleCatchAndReturnResult(error: error, stck: stck);
    }
  }
}
