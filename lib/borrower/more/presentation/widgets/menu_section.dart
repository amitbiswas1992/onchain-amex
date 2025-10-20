import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/utils/sizebox_util.dart';
import '../../../../core/widgets/containers/icon_outer_circle.dart';
import '../../../../core/widgets/texts/text_styles.dart';

class MenuSection extends StatelessWidget {
  final String? title;
  final List<Widget> items;

  const MenuSection({
    super.key,
    this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: s18W600(
              context,
              fontFamily: segoeProFontFamily,
            ),
          ),
        ],
        const VerticalSpace(AppValues.paddingMedium),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          // separatorBuilder: (context, index) =>
          //     const VerticalSpace(AppValues.paddingSmall),
          itemBuilder: (context, index) => items[index],
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final VoidCallback onTap;
  final Color? color;
  final bool arrowTopRight;
  final bool showTrailingIcon;
  final bool doNotUseIconColor;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitleWidget,
    this.subtitle,
    required this.onTap,
    this.color,
    this.arrowTopRight = false,
    this.showTrailingIcon = true,
    this.doNotUseIconColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            IconOuterCircle(
              icon: SvgPicture.asset(
                icon,
                color: doNotUseIconColor
                    ? null
                    : color ?? Theme.of(context).iconTheme.color,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: s14W600(context).copyWith(
                        // color: color,
                        ),
                  ),
                  if (subtitle != null || subtitleWidget != null) ...[
                    const SizedBox(height: 4),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 3,
                        style: s12W400(context).copyWith(
                          color: color,
                        ),
                      ),
                    if (subtitleWidget != null) subtitleWidget!,
                  ],
                ],
              ),
            ),
            if (showTrailingIcon)
              if (arrowTopRight)
                SvgPicture.asset('assets/icons/arrow_up_right.svg')
              else
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.c455468,
                ),
          ],
        ),
      ),
    );
  }
}

class MenuItemToggle extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final String option1;
  final String option2;
  final String currentValue;
  final Function(String) onChanged;
  final Color? color;
  final bool doNotUseIconColor;

  const MenuItemToggle({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.option1,
    required this.option2,
    required this.currentValue,
    required this.onChanged,
    this.color,
    this.doNotUseIconColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          IconOuterCircle(
            icon: SvgPicture.string(
              icon,
              color: doNotUseIconColor
                  ? null
                  : color ?? Theme.of(context).iconTheme.color,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: s14W600(context),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    maxLines: 3,
                    style: s12W400(context).copyWith(
                      color: color,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.borderColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggleOption(context, option1),
                _buildToggleOption(context, option2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(BuildContext context, String option) {
    final isSelected = currentValue == option;
    return InkWell(
      onTap: () => onChanged(option),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          option,
          style: s12W600(context).copyWith(
            color: isSelected ? Colors.white : AppColors.c455468,
          ),
        ),
      ),
    );
  }
}
