import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/appbars/primary_app_bar.dart';
import '../../../../core/widgets/buttons/app_primary_button.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class PersonalInformationScreen extends ConsumerStatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  ConsumerState createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends ConsumerState<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController(text: 'Shakir Ahmed');
  final _preferredNameController = TextEditingController(text: 'Shakir');
  final _dateOfBirthController = TextEditingController(text: '29 / 07 / 1996');
  final _phoneController = TextEditingController(text: '+8801790300838');
  final _addressController =
      TextEditingController(text: 'House 09, Road 02, Section C, Mirpur');
  final _cityController = TextEditingController(text: 'Dhaka');
  final _zipcodeController = TextEditingController(text: '1221');

  String _selectedCountry = 'Bangladesh';
  String _selectedNationality = 'Bangladesh';

  @override
  void dispose() {
    _fullNameController.dispose();
    _preferredNameController.dispose();
    _dateOfBirthController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipcodeController.dispose();
    super.dispose();
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
                FormDropdownField(
                  value: _selectedCountry,
                  items: const ['Bangladesh', 'India', 'Pakistan', 'Nepal'],
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value!;
                    });
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // Full legal name
                const FormFieldLabel(label: 'Full legal name'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  controller: _fullNameController,
                  hintText: 'Enter your full legal name',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // Preferred name
                const PreferredNameLabel(),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  controller: _preferredNameController,
                  hintText: 'Enter preferred name',
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // Date of birth
                const FormFieldLabel(label: 'Date of birth'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  controller: _dateOfBirthController,
                  hintText: 'DD / MM / YYYY',
                  prefixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Date of birth is required';
                    }
                    return null;
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // Phone number
                const FormFieldLabel(label: 'Phone number'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  controller: _phoneController,
                  hintText: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // Home Address
                const FormFieldLabel(label: 'Home Address'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  controller: _addressController,
                  hintText: 'Enter your home address',
                  maxLines: 3,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Address is required';
                    }
                    return null;
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // City
                const FormFieldLabel(label: 'City'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  controller: _cityController,
                  hintText: 'Enter city',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // Zipcode
                const FormFieldLabel(label: 'Zipcode'),
                const VerticalSpace(AppValues.paddingSmall),
                AppTextFormField(
                  controller: _zipcodeController,
                  hintText: 'Enter zipcode',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Zipcode is required';
                    }
                    return null;
                  },
                ),
                const VerticalSpace(AppValues.paddingMedium),

                // Nationality
                const FormFieldLabel(label: 'Nationality'),
                const VerticalSpace(AppValues.paddingSmall),
                FormDropdownField(
                  value: _selectedNationality,
                  items: const [
                    'Bangladesh',
                    'Indian',
                    'Pakistani',
                    'Nepalese',
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedNationality = value!;
                    });
                  },
                ),

                const VerticalSpace(AppValues.paddingLarge * 2),
                Align(
                  child: Text(
                    'By continuing, you confirm this information is correct.',
                    style: s11W400(context),
                    textAlign: TextAlign.center,
                  ),
                ),
                const VerticalSpace(AppValues.paddingSmall),
                const AppPrimaryButton(title: 'Confirm'),
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
      setState(() {
        _dateOfBirthController.text =
            '${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
      });
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
