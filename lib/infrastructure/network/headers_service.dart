import 'package:flutter/foundation.dart';


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
    return null;
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
    return null;
  }
}
