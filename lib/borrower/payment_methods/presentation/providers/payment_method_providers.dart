import 'package:flutter_riverpod/flutter_riverpod.dart';

final cardSavedProvider = StateProvider.autoDispose<bool>((ref) => false);