import 'package:flutter/material.dart';

import '../../Constants/colors.dart';

class textField extends StatelessWidget {
  const textField(
      {Key? key,
      required this.color,
      required this.baseColor,
      required this.controller,
      required this.labelText,
      this.hideText = false,
      required this.icon,
      required this.icon2
      // required this.textFieldFunction
      })
      : super(key: key);

  final String labelText;
  final TextEditingController controller;
  final bool hideText;
  final Icon icon;
  final  Color color;
  final Color baseColor;
  final Widget icon2;
  // final Function textFieldFunction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // validator: textFieldFunction(),
      cursorColor: primaryColor.withOpacity(0.7),
      controller: controller,
      obscureText: hideText,
      maxLines: 1,
      decoration: InputDecoration(
          // contentPadding: EdgeInsets.only(left: 10, right: 10),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: baseColor,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: icon,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: icon2,
          ),
          focusColor: color,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: color, width: 0.2)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide(color: color.withOpacity(0.5), width: 0.2)),
          labelText: labelText,
          labelStyle: TextStyle(color: color.withOpacity(0.6))),
    );
  }
}
