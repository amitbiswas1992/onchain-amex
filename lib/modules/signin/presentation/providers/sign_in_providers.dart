import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCountryCodeProvider = StateProvider.autoDispose(
  (ref) => CountryCode(name: 'United States', code: 'US', dialCode: '+1'),
);
