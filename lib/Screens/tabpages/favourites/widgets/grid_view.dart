import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Constants/colors.dart';
import '../../../../Provider/item_provider..dart';

class Gridview extends StatelessWidget {
  const Gridview(
      {Key? key, required this.snapshot, required this.size, required this.uid, required this.context2})
      : super(key: key);

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final Size size;
  final String uid;
  final BuildContext context2;
  @override
  Widget build(BuildContext context) {
    final theme = MediaQuery.of(context).platformBrightness;
    final List list = snapshot.data!.docs;
    return SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final QueryDocumentSnapshot product = list[index];
          return GridTile(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              child: InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed('/productDetail', arguments: product),
                child: Image.network(
                  list[index]['imagepath'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            footer: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: GridTileBar(
                backgroundColor: theme == Brightness.dark
                    ? Colors.black26
                    : screenColor.withOpacity(0.5),
                title: Text(
                  list[index]['title'],
                  style: TextStyle(
                      color: theme == Brightness.dark
                          ? screenColor
                          : primaryDarkColor),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    list[index]['imagepath'],
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.favorite_rounded,
                    color: primaryColor,
                  ),
                  onPressed: () async {
                    await Provider.of<Itemprovider>(context, listen: false)
                        .addtoFavourites(list[index], uid);
                       final SnackBar showSnackBar =
                              snackBar('Removed from favourites', 2);
                          ScaffoldMessenger.of(context2)
                              .showSnackBar(showSnackBar);
                  },
                ),
              ),
            ),
          );
        }, childCount: list.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: size.height * 0.2,
          childAspectRatio: 2,
          mainAxisSpacing: size.width * 0.1,
          crossAxisSpacing: size.width * 0.05,
        ));
  }
}
