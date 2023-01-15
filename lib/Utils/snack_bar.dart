import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';

SnackBar snackBar(String text, int time) {
  return SnackBar(
    backgroundColor: primaryColor,
    content: Text(text),
    duration: const Duration(seconds: 1),
  );
}
