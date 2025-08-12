import 'package:flutter/material.dart';

void unFocus(BuildContext context) => FocusScope.of(context).unfocus();

bool isLightTheme(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light;