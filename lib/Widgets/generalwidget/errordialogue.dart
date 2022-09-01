import 'package:flutter/material.dart';

errorDialogue (BuildContext context) {
  showDialog(context: context, builder: ((context) {
    return AlertDialog(
      content: const Text('User does not exist'),
      actions: [
        TextButton(onPressed: () {}, child: const Text('Ok!'))
      ],
    );
  }));
}