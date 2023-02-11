import 'package:flutter/material.dart';

import '../../../Models/item-model.dart';

ListTile search_ListTile(ItemModel result, BuildContext context) {
  final size = MediaQuery.of(context).size;
  return ListTile(
    title: Text(result.title),
    subtitle: Text(result.description),
    leading: CircleAvatar(
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      radius: size.width * 0.1,
      child: FadeInImage(
        fadeOutDuration: const Duration(milliseconds: 200),
        fadeOutCurve: Curves.easeOutBack,
        placeholder: const AssetImage('assets/harvest.png'),
        image: NetworkImage(
          result.imagepath,
        ),
        placeholderFit: BoxFit.scaleDown,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        imageErrorBuilder: ((context, error, stackTrace) => Center(
              child: Image.asset(
                'assets/Error_images/3d-render-red-paper-clipboard-with-cross-mark.jpg',
                fit: BoxFit.fitHeight,
              ),
            )),
      ),
    ),
    onTap: () {
      Navigator.of(context)
          .pushNamed('/searchResult', arguments: result).then((value) => Navigator.pop(context));
    },
  );
}
