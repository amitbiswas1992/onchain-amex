import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/di/global_providers.dart';
import '../../data/repositories/kyc_repo.dart';

final kycRepo = Provider<KycRepo>((ref) => KycRepo(dioService: ref.read(dioService)));