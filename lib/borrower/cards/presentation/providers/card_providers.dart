import 'package:flutter_riverpod/flutter_riverpod.dart';

final cardAddedProvider = StateProvider.autoDispose<bool>((ref) => false);