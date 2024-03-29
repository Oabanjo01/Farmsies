import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';

SnackBar snackBar(BuildContext context, String text, int time, [width, color]) {
    final theme = Theme.of(context).brightness;
  return SnackBar(
    width: width,
    shape: const StadiumBorder(),
    behavior: SnackBarBehavior.floating,
    elevation: 0.5,
    backgroundColor: color ?? primaryColor.withOpacity(0.4),
    margin: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
    content: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600 , color: theme == Brightness.dark ? textDarkColor : textColor)),
    duration: Duration(seconds: time),
  );
}
