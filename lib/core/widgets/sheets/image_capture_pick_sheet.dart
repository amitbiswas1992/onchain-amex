import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

class ImageCapturePickSheet extends StatelessWidget {
  final Function() onCaptureTap;
  final Function() onPickTap;
  final Function()? onFilePickTap;

  const ImageCapturePickSheet({
    super.key,
    required this.onCaptureTap,
    required this.onPickTap,
    this.onFilePickTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 32,
                    color: AppColors.deemGray,
                  ),
                  onPressed: onCaptureTap,
                ),
                const SizedBox(height: 8),
                const Text('Camera'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.photo_library,
                    size: 32,
                    color: AppColors.deemGray,
                  ),
                  onPressed: onPickTap,
                ),
                const SizedBox(height: 8),
                const Text('Gallery'),
              ],
            ),
            if (onFilePickTap != null)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.folder,
                      size: 32,
                      color: AppColors.deemGray,
                    ),
                    onPressed: onFilePickTap,
                  ),
                  const SizedBox(height: 8),
                  const Text('File'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
