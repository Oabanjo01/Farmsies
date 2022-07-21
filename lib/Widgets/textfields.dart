import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';


class textField extends StatelessWidget {
  const textField({
    Key? key,
    required this.controller,
    required this.helperText,
    this.hideText = false, required this.icon
  }) : super(key: key);
  
  final String helperText;
  final TextEditingController controller;
  final bool hideText;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: primaryColor.withOpacity(0.7),
      controller: controller,
      obscureText: hideText,
      maxLines: 1,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.only(left: 10, right: 10),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: icon, 
        ),
        focusColor: primaryColor,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                color: primaryColor, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                color: primaryColor.withOpacity(0.5), width: 1.5)),
        helperText: helperText,
        helperStyle: TextStyle(color: primaryColor.withOpacity(0.6))),
    );
  }
}