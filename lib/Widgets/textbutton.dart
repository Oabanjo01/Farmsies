import 'package:flutter/material.dart';

import '../Constants/colors.dart';


class Textbutton extends StatelessWidget {
  Textbutton({
    Key? key,
    required this.text
  }) : super(key: key);

  String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Aleady have an account?'),
        TextButton(
          style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(primaryColor.withOpacity(0.3))),
          onPressed: () {
            Navigator.pushNamed(context, '/signupScreen');
          },
          child: Text(
            text,
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }
}
