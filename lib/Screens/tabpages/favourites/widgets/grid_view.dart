import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Constants/colors.dart';
import '../../../../Provider/item_provider..dart';

class Gridview extends StatefulWidget {
  const Gridview(
      {Key? key,
      required this.snapshot,
      required this.size,
      required this.uid,
      required this.context2})
      : super(key: key);

  final AsyncSnapshot<QuerySnapshot> snapshot;
  final Size size;
  final String uid;
  final BuildContext context2;

  @override
  State<Gridview> createState() => _GridviewState();
}

class _GridviewState extends State<Gridview> {
  late QueryDocumentSnapshot product;

  void listentoProductChanges() {
    FirebaseFirestore.instance.collection('Products').get().then((value) {
      value.docs.where((element) => element['']);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness;
    final provider = Provider.of<Itemprovider>(context);
    final List<QueryDocumentSnapshot> list = widget.snapshot.data!.docs;
    return SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final QueryDocumentSnapshot product = list[index];
          return GridTile(
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
                    provider.toggler(
                        list[index],
                        widget.uid,
                        'Favourites',
                        1,
                        context,
                        'Removed from favourites',
                        'Removed from favourites');
                  },
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              child: InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed('/productDetail', arguments: product),
                child: Image.network(
                  list[index]['imagepath'],
                  errorBuilder: (context, error, stackTrace) =>  Image.asset(
                              'assets/Error_images/3d-render-red-paper-clipboard-with-cross-mark.jpg',
                              fit: BoxFit.fitHeight),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }, childCount: list.length),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: widget.size.height * 0.2,
          childAspectRatio: 2,
          mainAxisSpacing: widget.size.width * 0.1,
          crossAxisSpacing: widget.size.width * 0.05,
        ));
  }
}
