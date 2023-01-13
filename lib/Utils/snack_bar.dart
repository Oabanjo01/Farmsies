import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';

SnackBar snackBar(String text, int time) {
  return SnackBar(
    backgroundColor: primaryColor,
    content: Text(text),
    duration: Duration(seconds: time),
  );
}
