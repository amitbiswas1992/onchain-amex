import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import '../resources/app_colors.dart';
import '../resources/app_values.dart';
import '../utils/sizebox_util.dart';
import 'app_text_form_field.dart';
import 'input_formatters/phone_input_formatter.dart';

class PhoneNumberTextField extends StatelessWidget {
  final BoxDecoration? decoration;
  final double? height;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<CountryCode>? onCountryCodeChanged;
  final FormFieldSetter<String>? onSave;
  final ValueChanged<String>? onFieldSubmitted;

  final FocusNode? focusNode;
  final Color? errorColor;
  final CountryCode countryCode;

  const PhoneNumberTextField({
    super.key,
    this.decoration,
    this.height,
    this.validator,
    this.onChanged,
    this.onSave,
    this.onFieldSubmitted,
    this.focusNode,
    this.errorColor,
    this.onCountryCodeChanged,
    required this.countryCode,
  });

  final _countryCodes = const ['+1', '+2', '+3'];

  @override
  Widget build(BuildContext context) {

    final isoCode = isoCodeConversionMap[countryCode.code] ?? IsoCode.US;

    return Row(
      children: [
        // Consumer(
        //   builder: (context, ref, _) {
        //     final selectedCode = ref.watch(selectedCountryCodeProvider);
        //
        //     return AppDropDownButton<String?>(
        //       items: _countryCodes,
        //       selectedItem: selectedCode ?? _countryCodes.first,
        //       decoration: decoration,
        //       height: height,
        //       onChanged: (value) {
        //         ref.read(selectedCountryCodeProvider.notifier).state = value;
        //       },
        //       isExpanded: false,
        //       itemBuilder: (value) {
        //         return Row(
        //           children: [
        //             Image.asset('assets/dummy/flag.png'),
        //             const HorizontalSpace(AppValues.paddingMedium),
        //             Text(
        //               value ?? _countryCodes.first,
        //               style: const TextStyle(
        //                 fontWeight: FontWeight.w700,
        //                 color: AppColors.primaryLight,
        //               ),
        //             ),
        //             const HorizontalSpace(AppValues.paddingSmall),
        //           ],
        //         );
        //       },
        //     );
        //   },
        // ),
        Container(
          height: height ?? AppValues.defaultInputBoxHeight + 5,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: decoration ??
              BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
          child: CountryCodePicker(
            onChanged: onCountryCodeChanged,
            favorite: const ['FR', 'IT', 'CA', 'UK', 'US'],
            initialSelection: 'US',
            flagWidth: 24,
            headerText: 'Select Code',
            showDropDownButton: true,
            hideSearch: false,
            boxDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppValues.borderRadiusLarge),
                topRight: Radius.circular(AppValues.borderRadiusLarge),
                bottomLeft: Radius.circular(AppValues.borderRadiusLarge),
                bottomRight: Radius.circular(AppValues.borderRadiusLarge),
              ),
            ),
            dialogItemPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: AppValues.paddingMedium,
            ),
            headerTextStyle: const TextStyle(
              color: AppColors.primaryLight,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            searchPadding: const EdgeInsets.symmetric(
              vertical: AppValues.paddingMedium,
              horizontal: AppValues.paddingMedium,
            ),
            builder: (countryCode) {
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset(
                      countryCode?.flagUri ?? '',
                      package: 'country_code_picker',
                      width: 24,
                    ),
                  ),
                  const HorizontalSpace(AppValues.paddingMedium - 2),
                  Text(
                    countryCode?.dialCode ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  const HorizontalSpace(AppValues.paddingSmall),
                  const ImageIcon(
                    AssetImage('assets/icons/arrow_down.png'),
                    size: 14,
                    color: AppColors.primaryLight,
                  ),
                ],
              );
            },
            flagDecoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
          ),
        ),
        const HorizontalSpace(AppValues.paddingMedium),
        Expanded(
          child: AppTextFormField(
            height: height ?? AppValues.defaultInputBoxHeight + 5,
            decoration: decoration,
            hintText: 'e.g. 555 123 4567',
            maxLines: 1,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLight,
            ),
            keyboardType: TextInputType.phone,
            validator: validator ??
                (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Phone number is required';
                  }

                  // Remove all non-digit characters
                  final digits = val.replaceAll(RegExp(r'\D'), '');

                  try {
                    final phoneNumber = PhoneNumber.parse(digits, destinationCountry: isoCode);

                    final isValid = phoneNumber.isValid(type: PhoneNumberType.mobile);

                    if (!isValid) {
                      return 'Invalid phone number for ${countryCode.code}';
                    }

                    return null; // ✅ Valid
                  } catch (_) {
                    return 'Invalid phone number format';
                  }
                },
            onChanged: onChanged,
            onSave: onSave,
            onFieldSubmitted: onFieldSubmitted,
            focusNode: focusNode,
            errorColor: errorColor,
            formatters: [
              PhoneInputFormatter(isoCode: isoCode),
            ],
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 11,
            ),
          ),
        ),
      ],
    );
  }
}
