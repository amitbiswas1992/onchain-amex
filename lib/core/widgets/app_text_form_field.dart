import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/app_colors.dart';
import '../resources/app_values.dart';
import '../utils/sizebox_util.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSave;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final String? initialValue;
  final ValueChanged<String>? onFieldSubmitted;
  final Color? bgColor;
  final int? maxLines;
  final int? minLines;
  final EdgeInsets? contentPadding;
  final BoxDecoration? decoration;
  final double? height;
  final FocusNode? focusNode;
  final Color? errorColor;
  final List<TextInputFormatter>? formatters;

  const AppTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.onSave,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
    this.hintStyle,
    this.initialValue,
    this.bgColor,
    this.maxLines,
    this.minLines,
    this.contentPadding,
    this.decoration,
    this.height,
    this.focusNode,
    this.errorColor,
    this.formatters,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: height ?? (maxLines == null ? AppValues.defaultInputBoxHeight : null),
      // decoration: decoration ??
      //     BoxDecoration(
      //       color: bgColor ?? Colors.white,
      //       borderRadius: BorderRadius.circular(25),
      //     ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        onSaved: onSave,
        onFieldSubmitted: onFieldSubmitted,
        initialValue: initialValue,
        maxLines: obscureText ? 1 : maxLines,
        minLines: minLines,
        style: textStyle ??
            const TextStyle(
              color: Colors.black,
            ),
        inputFormatters: formatters,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: hintStyle ??
              const TextStyle(
                color: AppColors.hintColor,
              ),
          filled: true,
          fillColor: bgColor ?? Colors.white,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
          errorStyle: TextStyle(
            color: errorColor ?? AppColors.yellowGreen,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
