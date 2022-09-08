import 'package:flutter/material.dart';

errorDialogue (BuildContext context, String error) {
  showDialog(context: context, builder: ((context) {
    return AlertDialog(
      content: Text(error),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: const Text('Ok!'))
      ],
    );
  }));
}