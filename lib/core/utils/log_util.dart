import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../infrastructure/error/app_exception.dart';
import '../../infrastructure/network/result.dart';

void catchLog({required Object error, required  StackTrace? stck}) {
  debugPrint(error.toString());
  debugPrint(stck.toString());
}

Result<T> handleCatchAndReturnResult<T>({required Object error, required  StackTrace? stck}) {
  debugPrint(error.toString());
  debugPrint(stck.toString());
  return Result<T>.error(AppException(message: error.toString()));
}

extension MapLogExtension on Map {
  void show({required String tag}) {
    log(jsonEncode(this));
  }
}