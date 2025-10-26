import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/dialogs.dart';

void unFocus(BuildContext context) => FocusScope.of(context).unfocus();

bool isLightTheme(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light;

Future<void> launchLink(String url, BuildContext context) async {
  if (!await launchUrl(Uri.parse(url))) {
    showErrorDialog(context: context, message: 'Could not launch $url');
  }
}
