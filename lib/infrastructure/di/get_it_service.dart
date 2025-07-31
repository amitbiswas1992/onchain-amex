import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/services/secured_storage_service.dart';
import 'package:get_it/get_it.dart';

import '../network/connectivity_service.dart';
import '../network/dio_service.dart';
import '../network/headers_service.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton(SecuredStorageService());
  getIt.registerSingleton(ConnectivityService());
  getIt.registerSingleton(DioService(headersService: HeadersService()));
}
