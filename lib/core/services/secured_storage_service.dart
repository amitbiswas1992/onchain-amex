import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorageService {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Future<void> saveUserData({required UserData userData}) async {
  //   await _storage.write(key: 'user_data', value: jsonEncode(userData.toJson()));
  // }
  //
  // Future<UserData?> getUserData() async {
  //   final userDataJson = await _storage.read(key: 'user_data');
  //   log('user Data => $userDataJson');
  //   if (userDataJson != null) {
  //     return UserData.fromJson(jsonDecode(userDataJson));
  //   }
  //   return null;
  // }
  //
  // Future<void> deleteUserData() async {
  //   await _storage.delete(key: 'user_data');
  // }
  //
  // Future<void> saveAppleCredentials({
  //   required String username,
  //   required String familyName,
  //   required String email,
  //   required String userIdentifier,
  //   required String token,
  // }) async {
  //   try {
  //     await _storage.write(key: 'apple_username', value: username);
  //     await _storage.write(key: 'family_name', value: familyName);
  //     await _storage.write(key: 'apple_email', value: email);
  //     await _storage.write(key: 'apple_user_identifier', value: userIdentifier);
  //     await _storage.write(key: 'token', value: token);
  //   } catch (error, stck) {
  //     debugPrint(error.toString());
  //     debugPrint(stck.toString());
  //   }
  // }
  //
  // Future<Map<String, String>?> getAppleCredentials() async {
  //   try {
  //     final username = await _storage.read(key: 'apple_username');
  //     final email = await _storage.read(key: 'apple_email');
  //     final userIdentifier = await _storage.read(key: 'apple_user_identifier');
  //     final token = await _storage.read(key: 'token');
  //     final familyName = await _storage.read(key: 'family_name');
  //     return username != null && email != null && userIdentifier != null && token != null
  //         ? {
  //             'username': username,
  //             'email': email,
  //             'userIdentifier': userIdentifier,
  //             'token': token,
  //             'family_name': familyName ?? '',
  //           }
  //         : null;
  //   } catch (error, stck) {
  //     debugPrint(error.toString());
  //     debugPrint(stck.toString());
  //     return null;
  //   }
  // }
  //
  // Future<void> deleteAppleCredentials() async {
  //   try {
  //     await _storage.delete(key: 'apple_username');
  //     await _storage.delete(key: 'apple_email');
  //     await _storage.delete(key: 'apple_user_identifier');
  //     await _storage.delete(key: 'token');
  //     await _storage.delete(key: 'family_name');
  //   } catch (error, stck) {
  //     debugPrint(error.toString());
  //     debugPrint(stck.toString());
  //   }
  // }
}
