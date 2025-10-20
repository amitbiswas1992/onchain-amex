import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/di/global_providers.dart';

final bottomNavSelectedIndexProvider = StateProvider.autoDispose((ref) => 0);
final repayInMonthProvider = StateProvider.autoDispose((ref) => 1);
final themeModeProvider = StateProvider.autoDispose<ThemeMode?>((ref) => null);
final savedThemeModeProvider = FutureProvider.autoDispose<ThemeMode?>((
  ref,
) async {
  return await ref.read(securedStorageService).getThemeMode();
});
