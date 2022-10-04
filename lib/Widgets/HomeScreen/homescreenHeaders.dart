import 'package:flutter/material.dart';

import '../../Constants/colors.dart';

class HomescreenHeader extends StatelessWidget {
  const HomescreenHeader({
    Key? key,
    required this.text1,
    this.text2,
    this.navigate
  }) : super(key: key);

  final String text1;
  final String? text2;
  final Function? navigate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(text1, style: const TextStyle(fontSize: 20),), 
        TextButton(child: Text(text2!, style: TextStyle(color: primaryColor),), onPressed: navigate!())
      ],),
    );
  }
}