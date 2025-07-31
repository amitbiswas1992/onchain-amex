import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

class ProfileImagePlaceHolder extends StatelessWidget {
  final double size;
  const ProfileImagePlaceHolder({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Icon(
        Icons.person,
        color: AppColors.hintColor,
        size: size,
      ),
    );
  }
}
