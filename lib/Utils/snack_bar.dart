import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';

SnackBar snackBar(String text, int time, [width, color]) {
  return SnackBar(
    width: width,
    shape: const StadiumBorder(),
    behavior: SnackBarBehavior.floating,
    elevation: 0.5,
    backgroundColor: color ?? primaryColor,
    content: Text(text, textAlign: TextAlign.center,),
    duration: Duration(seconds: time),
  );
}
