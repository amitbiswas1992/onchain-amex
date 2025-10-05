import 'package:country_picker/country_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/dialogs.dart';
import '../../../../infrastructure/navigation/app_nav.dart';
import '../../../../infrastructure/network/result.dart';
import '../../business/repository/profile_repo_interface.dart';
import '../../data/models/profile.dart';
import '../providers/more_providers.dart';

class ProfileController {
  final BuildContext context;
  final WidgetRef ref;
  final ProfileRepoInterface profileRepo;

  const ProfileController({
    required this.context,
    required this.ref,
    required this.profileRepo,
  });

  Future<void> updateProfile({
    required Profile profile,
    required String userName,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required DateTime? dateOfBirth,
    required String address,
    required String city,
    required String state,
    required String postalCode,
    required Country? country,
}) async {

    if (profile.country == null && country == null) {
      showErrorDialog(context: context, message: 'Please select a country');
      return;
    }

    if (profile.dateOfBirth == null && dateOfBirth == null) {
      showErrorDialog(context: context, message: 'Please select a date of birth');
      return;
    }

    final payload = {
      "username": profile.username,
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": profile.phoneNumber,
      "dateOfBirth": dateOfBirth == null ? profile.dateOfBirth : dateOfBirth.toString().split(' ')[0],
      "address": address,
      "city": city,
      "state": state,
      "postalCode": postalCode,
      "country": country == null ? profile.country : country.name,
    };

    showLoadingDialog(context: context, message: 'Updating your profile...');
    final result = await profileRepo.updateProfile(payload: payload);
    hideDialog();

    switch (result) {
      case Ok():
        ref.invalidate(profileProvider);
        showSuccessDialog(
          context: context,
          message: result.message,
          dismissible: false,
          onDone: () {
            AppNav.goRouter.pop();
          },
        );
      case Error():
        showErrorDialog(context: context, message: result.toString());
    }
  }
}
