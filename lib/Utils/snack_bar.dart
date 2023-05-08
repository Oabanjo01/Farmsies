import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';

SnackBar snackBar(BuildContext context, String text, int time, [width, color]) {
    final theme = Theme.of(context).brightness;
  return SnackBar(
    width: width,
    shape: const StadiumBorder(),
    behavior: SnackBarBehavior.floating,
    elevation: 0.5,
    backgroundColor: color ?? primaryColor.withOpacity(0.2),
    content: Text(text, textAlign: TextAlign.center, style: TextStyle(color: theme == Brightness.dark ? textDarkColor : textDarkColor)),
    duration: Duration(seconds: time),
  );
}
