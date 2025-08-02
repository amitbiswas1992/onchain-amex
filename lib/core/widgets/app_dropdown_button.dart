import 'package:flutter/material.dart';

import '../resources/app_colors.dart';
import '../resources/app_values.dart';

class AppDropDownButton<T> extends StatelessWidget {
  final List<T> items;
  final T selectedItem;
  final void Function(T?) onChanged;
  final Widget Function(T) itemBuilder;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final bool? isExpanded;
  final BoxDecoration? decoration;
  final double? height;

  const AppDropDownButton({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemBuilder,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.padding,
    this.isExpanded, this.decoration, this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height ?? AppValues.defaultInputBoxHeight,
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 0,
        // vertical: 0,
      ),
      alignment: Alignment.center,
      decoration:decoration ?? BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isDense: false,
          value: selectedItem,
          icon: const ImageIcon(
            AssetImage('assets/icons/dropdown_arrow.png'),
            size: 14,
            color: AppColors.primaryLight,
          ),
          style: TextStyle(color: textColor, fontSize: 16),
          // dropdownColor: Colors.black,
          onChanged: onChanged,
          isExpanded: isExpanded ?? false,
          padding: EdgeInsets.zero,
          items: items.map((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Builder(builder: (context) {
                return itemBuilder(value);
              },),
            );
          }).toList(),
        ),
      ),
    );
  }
}
