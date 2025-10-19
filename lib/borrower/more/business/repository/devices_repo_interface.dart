import '../../../../infrastructure/network/result.dart';
import '../../data/models/device_session.dart';

abstract interface class DevicesRepoInterface {
  Future<Result<List<DeviceSession>?>> getSignedDevices();
  Future<Result> deleteDeviceSession({required String deviceID});
}