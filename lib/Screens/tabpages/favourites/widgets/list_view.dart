import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Constants/colors.dart';
import '../../../../Provider/item_provider..dart';
import '../../../../Utils/snack_bar.dart';

class Listview extends StatelessWidget {
  const Listview({
    Key? key,
    required this.size,
    required this.snapshot,
    required this.uid,
    required this.context2,
  }) : super(key: key);

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final Size size;
  final String uid;
  final BuildContext context2;

  @override
  Widget build(BuildContext context) {
    final theme = MediaQuery.of(context).platformBrightness;
    final List list = snapshot.data!.docs;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        ((context, index) {
          final QueryDocumentSnapshot product = list[index];
          return Column(
            children: [
              ListTile(
                onTap: () => Navigator.of(context).pushNamed(
                  '/productDetail',
                  arguments: product,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.width * 0.04),
                ),
                style: ListTileStyle.list,
                contentPadding: EdgeInsets.all(size.width * 0.02),
                tileColor:
                    theme == Brightness.light ? screenColor : primaryColor,
                title: Text(list[index]['title']),
                leading: SizedBox(
                  height: size.width * 0.15,
                  width: size.width * 0.15,
                  child: ClipRRect(
                    child: Image.network(
                      list[index]['imagepath'],
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : Center(
                                  child: CircularProgressIndicator(
                                      color: primaryColor),
                                ),
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          'Error, might be your internet',
                          style: TextStyle(color: errorColor),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(size.width * 0.05),
                    ),
                  ),
                ),
                trailing: SizedBox(
                  width: size.width * 0.2,
                  child: IconButton(
                    onPressed: () async {
                      await Provider.of<Itemprovider>(context, listen: false)
                          .addtoFavourites(list[index], uid)
                          .then((value) {
                        final SnackBar showSnackBar =
                            snackBar('Removed from favourites', 2);
                        ScaffoldMessenger.of(context2)
                            .showSnackBar(showSnackBar);
                      });
                    },
                    icon: Icon(
                      Icons.favorite_rounded,
                      color: theme == Brightness.light
                          ? primaryColor
                          : screenColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          );
        }),
        childCount: list.length,
      ),
    );
  }
}
