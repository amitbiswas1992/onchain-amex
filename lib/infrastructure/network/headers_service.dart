import 'package:flutter/foundation.dart';

import '../../core/services/secured_storage_service.dart';


class HeadersService {

  final SecuredStorageService securedStorageService;

  HeadersService({required this.securedStorageService});

  final Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'accept': '*/*',
  };

  Future<Map<String, String>?> getTokenizedHeaders() async {
    try {
      final tokens = await securedStorageService.getUserTokens();
      if (tokens == null) return null;
      return {
        'Content-Type': 'application/json',
        'accept': '*/*',
        'Authorization': 'Bearer ${tokens.accessToken}',
      };
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      return null;
    }
  }

  Future<Map<String, String>?> getMultipartTokenizedHeaders() async {
    try {
      final tokens = await securedStorageService.getUserTokens();
      if (tokens == null) return null;
      return {
        // 'Content-Type': 'application/json',
        'accept': '*/*',
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ${tokens.accessToken}',
      };
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
      return null;
    }
  }
}
