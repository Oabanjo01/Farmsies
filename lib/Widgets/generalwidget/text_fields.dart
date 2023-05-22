// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../../Screens/search/widget/search_bar.dart';

class textField extends StatelessWidget {
  const textField({
    Key? key,
    required this.color,
    required this.baseColor,
    required this.labelText,
    required this.icon,
  }) : super(key: key);

  final String labelText;
  final Icon icon;
  final Color color;
  final Color baseColor;
  // final Function textFieldFunction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        showSearch(context: context, delegate: CustomSearchBar());
      },
      readOnly: true,
      cursorColor: primaryColor.withOpacity(0.7),
      maxLines: 1,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        fillColor: baseColor,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: icon,
        ),
        hintText: labelText,
        hintStyle: TextStyle(
          color: color.withOpacity(
            0.6,
          ),
        ),
        focusColor: color,
        focusedBorder: border(0.8),
        enabledBorder: border(0.3),
        labelText: labelText,
        labelStyle: TextStyle(
          color: color.withOpacity(
            0.6,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder border(width) {
    return OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: width));
  }
}
