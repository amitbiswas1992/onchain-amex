import 'package:flutter/services.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class PhoneInputFormatter extends TextInputFormatter {
  final IsoCode isoCode;

  PhoneInputFormatter({required this.isoCode});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final rawDigits = newValue.text.replaceAll(RegExp(r'\D'), '');

    try {
      final phoneNumber = PhoneNumber.parse(rawDigits, destinationCountry: isoCode);
      final formatted = phoneNumber.formatNsn();

      int offset = formatted.length;

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: offset),
      );
    } catch (_) {
      return newValue;
    }
  }
}
