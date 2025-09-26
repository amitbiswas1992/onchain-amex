import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../infrastructure/di/global_providers.dart';
import '../../data/repositories/sign_in_repo.dart';

final selectedCountryCodeProvider = StateProvider.autoDispose(
  (ref) => CountryCode(name: 'United States', code: 'US', dialCode: '+1'),
);

final signInRepoProvider = Provider.autoDispose(
  (ref) => SignInRepo(
    dioService: ref.read(dioService),
  ),
);
