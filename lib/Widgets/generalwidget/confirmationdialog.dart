import 'package:farmsies/Widgets/generalwidget/textbutton.dart';
import 'package:flutter/material.dart';

confirm ({required String title, required String content, required Function() onClicked1, required Function() onClicked2, required String textbutton1, required String textbutton2, required BuildContext context}) {
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      elevation: 0,
       
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(child: Text(textbutton1), onPressed: onClicked1,),
        TextButton(child: Text(textbutton2), onPressed: onClicked2,)
      ],
    );
  },);
}