import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/device_info_service.dart';
import '../../core/services/secured_storage_service.dart';
import '../../core/services/web3_service.dart';
import '../network/connectivity_service.dart';
import '../network/dio_service.dart';
import '../network/headers_service.dart';

final deviceInfoService = Provider((ref) => DeviceInfoService());
final securedStorageService = Provider((ref) => SecuredStorageService());
final headerService = Provider((ref) =>
    HeadersService(securedStorageService: ref.read(securedStorageService)));
final connectivityService = Provider((ref) => ConnectivityService());
final dioService = Provider((ref) => DioService(
    headersService: ref.read(headerService),
    connectivityService: ref.read(connectivityService)));

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final web3ServiceProvider = Provider((ref) {
  return Web3Service(ref.read(sharedPreferencesProvider));
});
