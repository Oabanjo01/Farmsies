import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future <String?> pickFile (BuildContext ctx) async {
  try {
    FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false
    );
    if (pickerResult != null) {
      String? pickedFile = pickerResult.files.single.path;
      Navigator.of(ctx).pop();
      return pickedFile;
    } else {
      return '';
    } 
  } catch (e) {
    return 'Something went wrong';
  }
}