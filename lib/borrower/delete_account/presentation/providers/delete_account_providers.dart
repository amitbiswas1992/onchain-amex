import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteAccountButtonEnabledProvider = StateProvider.autoDispose<bool>((ref) => false);