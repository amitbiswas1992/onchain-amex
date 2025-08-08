import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../infrastructure/navigation/app_nav.dart';
import '../../resources/app_values.dart';
import '../../utils/sizebox_util.dart';
import '../texts/text_styles.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onLeadingPressed;
  final List<Widget>? actions;
  final double height;

  const PrimaryAppBar({
    super.key,
    this.title,
    this.onLeadingPressed,
    this.actions,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top), // For status bar
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: onLeadingPressed ?? () {
              AppNav.goRouter.pop();
            },
            child: Container(
              height: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const HorizontalSpace(AppValues.paddingMedium),
                  const SizedBox(
                    width: 18,
                    child: Icon(
                      CupertinoIcons.chevron_left,
                      size: 24,
                    ),
                  ),
                  const HorizontalSpace(AppValues.paddingSmall),
                  Text(
                    'Back',
                    style: s17W400(context),
                  ),
                  const HorizontalSpace(AppValues.paddingSmall),
                ],
              ),
            ),
          ),
          title == null
              ? const SizedBox()
              : Expanded(
                  child: Text(
                    title ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
