import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/app_colors.dart';
import '../resources/app_values.dart';
import '../utils/sizebox_util.dart';
import 'texts/text_styles.dart';

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
  final bool? autoFocus;

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
    this.formatters, this.autoFocus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      // height: height ?? (maxLines == null ? AppValues.defaultInputBoxHeight : null),
      // decoration: decoration ??
      //     BoxDecoration(
      //       color: bgColor ?? Colors.white,
      //       borderRadius: BorderRadius.circular(25),
      //     ),
      child: TextFormField(
        controller: controller,
        autofocus: autoFocus ?? false,
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
            s14W500(context).copyWith(color: theme.colorScheme.onSurface),
        inputFormatters: formatters,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: hintStyle ??
              s14W400(context).copyWith(
                color: AppColors.cAFBACA,
              ),
          filled: true,
          fillColor: bgColor ?? theme.colorScheme.surface,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
          errorStyle: TextStyle(
            color: errorColor ?? theme.colorScheme.error,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: AppColors.borderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: AppColors.borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: AppColors.borderColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }
}
