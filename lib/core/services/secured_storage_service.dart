import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../modules/signin/data/models/tokens_model.dart';

class SecuredStorageService {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _storage.write(key: 'theme_mode', value: mode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<ThemeMode> getThemeMode() async {
    final mode = await _storage.read(key: 'theme_mode');
    return mode == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> markAsOnboarded() async {
    await _storage.write(key: 'onboarded', value: 'true');
  }

  Future<bool> isOnboarded() async {
    final onboarded = await _storage.read(key: 'onboarded');
    return onboarded == 'true';
  }

  Future<void> saveUserTokens(TokensModel tokenModel) async {
    await _storage.write(key: 'user_token', value: jsonEncode(tokenModel.toJson()));
  }

  Future<TokensModel?> getUserTokens() async {
    final token = await _storage.read(key: 'user_token');
    if (token != null) {
      return TokensModel.fromJson(jsonDecode(token));
    }
    return null;
  }

  Future<void> deleteUserTokens() async {
    try {
      return await _storage.delete(key: 'user_token');
    } catch (error, stck) {
      debugPrint(error.toString());
      debugPrint(stck.toString());
    }
  }

}
