import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Constants/colors.dart';
import '../../../../Provider/item_provider..dart';

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
    final theme = Theme.of(context).brightness;
    final List list = snapshot.data!.docs;
    final provider = Provider.of<Itemprovider>(context);
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
                    theme == Brightness.light ? screenDarkColor.withOpacity(0.1) : screenColor.withOpacity(0.06),
                title: Text(list[index]['title']),
                leading: SizedBox(
                  height: size.width * 0.15,
                  width: size.width * 0.15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(size.width * 0.05),
                    ),
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
                  ),
                ),
                trailing: SizedBox(
                  width: size.width * 0.2,
                  child: IconButton(
                    onPressed: () async {
                      provider.toggler(list[index], uid, 'Favourites', 1, context, 'Removed from favourites', 'Removed from favourites');
                    },
                    icon: Icon(
                      Icons.favorite_rounded,
                      color: primaryColor
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
