import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_picker_button.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';
import '../../data/models/profile.dart';
import '../controllers/profile_controller.dart';
import '../providers/more_providers.dart';

class PersonalInformationScreen extends ConsumerStatefulWidget {
  final Profile profile;

  const PersonalInformationScreen({super.key, required this.profile});

  @override
  ConsumerState createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends ConsumerState<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ProfileController _profileController;

  final firstNameNode = FocusNode();
  final lastNameNode = FocusNode();
  final homeAddressNode = FocusNode();
  final cityNode = FocusNode();
  final stateNode = FocusNode();
  final zipCodeNode = FocusNode();

  String firstName = '';
  String lastName = '';
  String homeAddress = '';
  String city = '';
  String state = '';
  String zipCode = '';

  @override
  void dispose() {
    firstNameNode.dispose();
    lastNameNode.dispose();
    homeAddressNode.dispose();
    cityNode.dispose();
    stateNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _profileController = ProfileController(
      context: context,
      ref: ref,
      profileRepo: ref.read(profileRepo),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: Scaffold(
        appBar: const PrimaryAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.paddingMedium),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal information',
                  style: s18W600(context),
                  textAlign: TextAlign.start,
                ),
                const VerticalSpace(AppValues.paddingLarge),

                // Country of residence
                const FormFieldLabel(label: 'Country of residence'),
                const VerticalSpace(AppValues.paddingSmall),
                Consumer(builder: (context, ref, _) {
                  final selected = ref.watch(selectedCountryProvider);

                  return AppPickerButton(
                    hint: 'Country',
                    value: selected?.name ?? widget.profile.country,
                    onTap: () async {
                      showCountryPicker(
                        context: context,
                        onSelect: (c) {
                          ref.read(selectedCountryProvider.notifier).state = c;
                        },
                      );
                    },
                    icon: const Icon(Icons.arrow_drop_down_sharp),
                  );
                }),
                const VerticalSpace(AppValues.paddingMedium),

                // Full legal name
                const FormFieldLabel(label: 'First Name'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  focusNode: firstNameNode,
                  hintText: 'Enter your first name',
                  initialValue: widget.profile.firstName,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'First name is required';
                    }
                    return null;
                  },
                  onSave: (val) {
                    firstName = val ?? '';
                  },
                  onFieldSubmitted: (val) {
                    firstNameNode.unfocus();
                    lastNameNode.requestFocus();
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),
                const FormFieldLabel(label: 'Last Name'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  focusNode: lastNameNode,
                  hintText: 'Enter your last name',
                  initialValue: widget.profile.lastName,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Last name is required';
                    }
                    return null;
                  },
                  onSave: (val) {
                    lastName = val ?? '';
                  },
                  onFieldSubmitted: (val) {
                    lastNameNode.unfocus();
                    homeAddressNode.requestFocus();
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // Date of birth
                const FormFieldLabel(label: 'Date of birth'),
                const VerticalSpace(AppValues.paddingSmall),
                Consumer(builder: (context, ref, _) {
                  final pickedDate = ref.watch(pickedDateProvider);

                  return AppPickerButton(
                    icon: const Icon(Icons.calendar_month_rounded),
                    hint: 'Pick date of birth',
                    value: pickedDate == null ? null : pickedDate.toString().split(' ')[0],
                    onTap: () {
                      _selectDate(context);
                    },
                  );
                }),
                const VerticalSpace(AppValues.paddingMedium),

                // Home Address
                const FormFieldLabel(label: 'Address'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  focusNode: homeAddressNode,
                  hintText: 'Enter your address',
                  initialValue: widget.profile.address,
                  maxLines: 3,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Address is required';
                    }
                    return null;
                  },
                  onSave: (val) {
                    homeAddress = val ?? '';
                  },
                  onFieldSubmitted: (val) {
                    homeAddressNode.unfocus();
                    cityNode.requestFocus();
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // City
                const FormFieldLabel(label: 'City'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  focusNode: cityNode,
                  hintText: 'Enter city',
                  initialValue: widget.profile.city,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'City is required';
                    }
                    return null;
                  },
                  onSave: (val) {
                    city = val ?? '';
                  },
                  onFieldSubmitted: (val) {
                    cityNode.unfocus();
                    stateNode.requestFocus();
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // City
                const FormFieldLabel(label: 'State'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  focusNode: stateNode,
                  hintText: 'Enter state',
                  initialValue: widget.profile.state,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'State is required';
                    }
                    return null;
                  },
                  onSave: (val) {
                    state = val ?? '';
                  },
                  onFieldSubmitted: (val) {
                    stateNode.unfocus();
                    zipCodeNode.requestFocus();
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // Zipcode
                const FormFieldLabel(label: 'Postal Code'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  focusNode: zipCodeNode,
                  hintText: 'Enter postal code',
                  keyboardType: TextInputType.number,
                  initialValue: widget.profile.postalCode,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Postal code is required';
                    }
                    return null;
                  },
                  onSave: (val) {
                    zipCode = val ?? '';
                  },
                  onFieldSubmitted: (val) {
                    zipCodeNode.unfocus();
                  },
                ),

                const VerticalSpace(AppValues.paddingLarge * 2),
                Align(
                  child: Text(
                    'By continuing, you confirm this information is correct.',
                    style: s11W400(context),˚
                    textAlign: TextAlign.center,
                  ),
                ),
                const VerticalSpace(AppValues.paddingSmall),
                SafeArea(
                  child: AppPrimaryButton(
                    title: 'Confirm',
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _profileController.updateProfile(
                          profile: widget.profile,
                          userName: widget.profile.username ?? '',
                          firstName: firstName,
                          lastName: lastName,
                          phoneNumber: widget.profile.phoneNumber ?? '',
                          dateOfBirth: ref.read(pickedDateProvider),
                          address: homeAddress,
                          city: city,
                          state: state,
                          postalCode: zipCode,
                          country: ref.read(selectedCountryProvider),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1996, 7, 29),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ref.read(pickedDateProvider.notifier).state = picked;
    }
  }
}

class FormFieldLabel extends StatelessWidget {
  final String label;

  const FormFieldLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: s14W500(context, fontFamily: interFontFamily).copyWith(
        color: AppColors.cAFBACA,
      ),
    );
  }
}

class PreferredNameLabel extends StatelessWidget {
  const PreferredNameLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const FormFieldLabel(label: 'Preferred name'),
        const HorizontalSpace(4),
        Text(
          '(Optional)',
          style: s14W400(context, fontFamily: interFontFamily).copyWith(
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.info_outline,
          size: 16,
          color: Colors.grey,
        ),
      ],
    );
  }
}

class FormDropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const FormDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(AppValues.borderRadiusSmall),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppValues.paddingMedium,
            vertical: AppValues.paddingMedium,
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: s16W400(context, fontFamily: interFontFamily),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}
