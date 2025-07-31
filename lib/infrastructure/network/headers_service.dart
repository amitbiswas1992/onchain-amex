import 'package:flutter/foundation.dart';

import '../../core/extensions/string_extension.dart';
import '../../core/services/secured_storage_service.dart';
import '../di/get_it_service.dart';

class HeadersService {
  final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'accept': '*/*',
  };

  Future<Map<String, String>?> getTokenizedHeaders() async {
    try {
      // final userData = await getIt<SecuredStorageService>().getUserData();
      // if (userData == null) return null;
      // return {
      //   'Content-Type': 'application/json',
      //   'accept': '*/*',
      //   'Authorization': 'Bearer ${userData.accessToken}',
      // };
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      return null;
    }
  }

  Future<Map<String, String>?> getMultipartTokenizedHeaders() async {
    try {
      // final userData = await getIt<SecuredStorageService>().getUserData();
      // if (userData == null) return null;
      // return {
      //   // 'Content-Type': 'application/json',
      //   'accept': '*/*',
      //   'Content-Type': 'multipart/form-data',
      //   'Authorization': 'Bearer ${userData.accessToken}',
      // };
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      return null;
    }
  }
}
