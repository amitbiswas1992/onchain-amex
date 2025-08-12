import 'package:flutter_riverpod/flutter_riverpod.dart';

final nfcCardScanStatusProvider = StateProvider.autoDispose((ref) => false);
final qrCodeScanStatusProvider = StateProvider.autoDispose((ref) => false);