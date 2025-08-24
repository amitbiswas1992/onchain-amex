import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavSelectedIndexProvider = StateProvider.autoDispose((ref) => 2);
final repayInMonthProvider = StateProvider.autoDispose((ref) => 1);
final themeModeProvider = StateProvider.autoDispose<ThemeMode?>((ref) => null);