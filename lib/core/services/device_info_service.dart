import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoService {

  final deviceInfo = DeviceInfoPlugin();

  Future<String> getDeviceFingerprint() async {
    String rawData = '';
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      rawData =
      '${info.brand}-${info.model}-${info.id}-${info.hardware}-${info.device}';
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      rawData =
      '${info.name}-${info.model}-${info.systemName}-${info.identifierForVendor}';
    }

    // Create SHA-256 hash for consistency
    final bytes = utf8.encode(rawData);
    return sha256.convert(bytes).toString();
  }

  Future<Map<String, String>> getLoginTimeDeviceInfo() async {
    String deviceName = '';
    String deviceType = 'mobile';
    String platform = '';
    String platformVersion = '';

    final packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      deviceName = info.model;
      platform = 'Android';
      platformVersion = info.version.release;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      deviceName = info.name;
      platform = 'iOS';
      platformVersion = info.systemVersion;
    }

    return {
      "deviceId": await getDeviceFingerprint(),
      "deviceName": deviceName,
      "deviceType": deviceType,
      "platform": platform,
      "platformVersion": platformVersion,
      "appVersion": packageInfo.version,
      "browserName": "",
      "browserVersion": "",
      "userAgent": "",
      "location": ""
    };
  }
}