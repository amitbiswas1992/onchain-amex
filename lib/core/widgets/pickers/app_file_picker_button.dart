import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;

import '../../../infrastructure/navigation/app_nav.dart';
import '../../../infrastructure/navigation/rt_nm.dart';
import '../../extensions/file_extension.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_values.dart';
import '../../utils/sizebox_util.dart';
import '../sheets/image_capture_pick_sheet.dart';
import '../texts/text_styles.dart';

class AppFilePickerButton extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final Function(List<File>) onPick;
  final List<File> pickedFiles;
  final String? hint;
  final Widget? icon;
  final EdgeInsets? padding;
  final double? height;
  final BoxDecoration? decoration;
  final ValueChanged<int>? onRemoveImage;

  const AppFilePickerButton({
    super.key,
    required this.onPick,
    this.borderRadius,
    this.backgroundColor,
    required this.pickedFiles,
    this.hint,
    this.icon,
    this.padding,
    this.height,
    this.decoration,
    this.onRemoveImage,
  });

  Future<XFile?> _pickImage(ImageSource source, BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 50);
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        InkWell(
          onTap: () async {
            showModalBottomSheet(
              context: context,
              backgroundColor: AppColors.whiteSmoke,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) {
                return ImageCapturePickSheet(
                  onCaptureTap: () async {
                    AppNav.navKey.currentState?.pop();
                    final picked = await _pickImage(ImageSource.camera, context);
                    if (picked != null) {
                      onPick([File(picked.path)]);
                    }
                  },
                  onPickTap: () async {
                    AppNav.navKey.currentState?.pop();
                    final picked = await _pickImage(ImageSource.gallery, context);
                    if (picked != null) {
                      onPick([File(picked.path)]);
                    }
                  },
                  onFilePickTap: () async {
                    AppNav.navKey.currentState?.pop();
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                      allowMultiple: true,
                    );
                    var files = result?.files.map((xf) => File(xf.path ?? '')).toList() ?? [];
                    final imageAndPdfFiles = <File>[];
                    for (var file in files) {
                      if (file.isImage() || file.isPdf()) {
                        imageAndPdfFiles.add(file);
                      }
                    }
                    onPick(imageAndPdfFiles);
                  },
                );
              },
            );
          },
          child: Container(
            // height: height ?? AppValues.defaultInputBoxHeight,
            decoration: decoration ??
                BoxDecoration(
                  color: backgroundColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius ?? 25),
                ),
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pick',
                    style: TextStyle(
                      color: AppColors.hintColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                const HorizontalSpace(8),
                icon ?? const SizedBox(),
              ],
            ),
          ),
        ),
        ListView.builder(
          itemCount: pickedFiles.length,
          padding: const EdgeInsets.symmetric(
            vertical: AppValues.paddingSmall,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final file = pickedFiles[index];
            final fileName = path.basename(file.path);
            Widget fileView = Container();

            if (file.isImage()) {
              fileView = ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(5),
                child: Image.file(
                  file,
                  width: size.width * .08,
                  height: size.width * .08,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              fileView = Image.asset(
                'assets/icons/pdf.png',
                width: size.width * .08,
                height: size.width * .08,
              );
            }

            return Container(
              padding: const EdgeInsets.only(bottom: AppValues.paddingSmall),
              child: GestureDetector(
                onTap: () {
                  if (file.isImage()) {
                    // AppNav.goRouter.push(RtNm.photoViewScreen, extra: file);
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    fileView,
                    const HorizontalSpace(6),
                    Expanded(
                      child: Text(
                        fileName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: sfPro14W500.copyWith(
                          color: AppColors.whiteSmoke,
                        ),
                      ),
                    ),
                    const HorizontalSpace(AppValues.paddingSmall),
                    InkResponse(
                      onTap: () {
                        onRemoveImage?.call(index);
                      },
                      child: const Icon(
                        CupertinoIcons.multiply,
                        color: AppColors.yellowGreen,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
