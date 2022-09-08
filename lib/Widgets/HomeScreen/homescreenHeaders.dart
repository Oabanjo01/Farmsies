import 'package:flutter/material.dart';

import '../../Constants/colors.dart';

class HomescreenHeader extends StatelessWidget {
  const HomescreenHeader({
    Key? key,
    required this.text1,
    required this.text2
  }) : super(key: key);

  final String text1;
  final String text2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(text1, style: TextStyle(fontSize: 20),), 
        TextButton(child: Text(text2, style: TextStyle(color: primaryColor),), onPressed: () {})
      ],),
    );
  }
}