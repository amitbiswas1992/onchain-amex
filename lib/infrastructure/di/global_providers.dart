import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/secured_storage_service.dart';
import '../network/connectivity_service.dart';
import '../network/dio_service.dart';
import '../network/headers_service.dart';

final securedStorageService = Provider((ref) => SecuredStorageService());
final headerService = Provider((ref) => HeadersService(securedStorageService: ref.read(securedStorageService)));
final connectivityService = Provider((ref) => ConnectivityService());
final dioService = Provider((ref) => DioService(headersService: ref.read(headerService), connectivityService: ref.read(connectivityService)));
