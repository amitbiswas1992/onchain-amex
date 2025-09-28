import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/di/global_providers.dart';
import '../../data/repositories/profile_repo.dart';

final profileRepo = Provider.autoDispose((ref) => ProfileRepo(dioService: ref.read(dioService)));
final profileProvider = FutureProvider.autoDispose((ref) async {
  return await ref.read(profileRepo).getProfile();
});