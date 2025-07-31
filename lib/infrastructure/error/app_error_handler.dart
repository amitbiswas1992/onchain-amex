import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../core/utils/log_util.dart';

class AppErrorHandler {

  /// Handle error from here
  /// Send logs to Firebase Crashlytics
  /// Send logs to own servers
  void handleError(Object error, StackTrace? stck) {
    catchLog(error: error, stck: stck);
  }

  void handleAllErrorsGlobally() {
    /// Handle All UI errors/exceptions
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      handleError(details.exception, details.stack);
      /// We can send this error log to Firebase crashlytics or on your own server
    };

    /// Handle All Native Platform Specific Errors/Exceptions
    PlatformDispatcher.instance.onError = (error, stck) {
      handleError(error, stck);
      return true;
    };
  }
}