// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future pickFile ({required BuildContext ctx, bool popBottomSheet = false, bool pickMultipleImages = false}) async {
  try {
    FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: pickMultipleImages
    );
    if (pickerResult != null) {
      if (pickMultipleImages == true) {
        List<File> files = pickerResult.paths.map((String? path) => File(path!)).toList();
        return files;
      }
      String? pickedFile = pickerResult.files.single.path;
      popBottomSheet == true ? Navigator.of(ctx).pop() : null;
      return pickedFile;
    } else {
      return '';
    } 
  } catch (e) {
    return 'Something went wrong';
  }
}
