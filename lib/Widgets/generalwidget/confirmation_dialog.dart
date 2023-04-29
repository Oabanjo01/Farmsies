import 'package:flutter/material.dart';

confirm ({required String title, required String content, required Function() onClicked1, required Function() onClicked2, required String textbutton1, required String textbutton2, required BuildContext context}) {
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      elevation: 0,
       
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: onClicked1,child: Text(textbutton1),),
        TextButton(onPressed: onClicked2,child: Text(textbutton2),)
      ],
    );
  },);
}

//