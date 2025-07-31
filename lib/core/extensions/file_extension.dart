import 'dart:io';

import '../utils/log_util.dart';

extension FileExtension on File {
  bool isImage() {
    try {
      final extension = this.path.toLowerCase().split('.').last;
      return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
    } catch (error, stck) {
      catchLog(error: error, stck: stck);
      return false;
    }
  }

  bool isPdf () {
    try {
      final extension = this.path.toLowerCase().split('.').last;
      return ['pdf'].contains(extension);
    } catch (error, stck) {
      catchLog(error: error, stck: stck);
      return false;
    }
  }
}