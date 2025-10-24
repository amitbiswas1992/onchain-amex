import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/di/global_providers.dart';
import '../../data/repositories/devices_repo.dart';
import '../../data/repositories/profile_repo.dart';

final profileRepo = Provider.autoDispose(
  (ref) => ProfileRepo(dioService: ref.read(dioService)),
);
final devicesRepo = Provider.autoDispose(
  (ref) => DevicesRepo(dioService: ref.read(dioService)),
);
final profileProvider = FutureProvider.autoDispose((ref) async {
  final profile = await ref.read(profileRepo).getProfile();
  // Only keep alive if successful
  return profile;
});

final selectedCountryProvider =
    StateProvider.autoDispose<Country?>((ref) => null);

final pickedDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

final merchantProfileProvider = FutureProvider.autoDispose((ref) async {
  return await ref.read(profileRepo).getMerchantProfile();
});
final deviceSessionsProvider = FutureProvider.autoDispose((ref) async {
  return await ref.read(devicesRepo).getSignedDevices();
});

final deviceFingerprintProvider = FutureProvider.autoDispose((ref) async {
  return await ref.read(deviceInfoService).getDeviceFingerprint();
});

final notificationEnabledProvider = StateProvider<bool>((ref) => true);
