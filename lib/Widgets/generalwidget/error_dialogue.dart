import 'package:flutter/material.dart';

errorDialogue(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        elevation: 0,
        content: Text(error),
        actions: [
          TextButton(
              onPressed: () {
                error == 'User with this email doesn\'t exist.'
                    ? Navigator.popAndPushNamed(context, '/signupScreen')
                    : Navigator.pop(context);
              },
              child: error == 'User with this email doesn\'t exist.'
                  ? const Text('Sign up?😊')
                  : const Text('Ok')),
        ],
      );
    }),
  );
}
