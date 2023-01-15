import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Provider/item_provider..dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../../../Constants/colors.dart';

class DealItem extends StatefulWidget {
  const DealItem({Key? key, required this.product}) : super(key: key);
  final QueryDocumentSnapshot product;

  @override
  State<DealItem> createState() => _DealItemState();
}

class _DealItemState extends State<DealItem> {
  bool exists = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final id = widget.product['id'];
    final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    final String uid = firebaseAuth.currentUser!.uid;
    final provider = Provider.of<Itemprovider>(context);
    return Column(children: [
      Flexible(
        fit: FlexFit.tight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(children: [
            Stack(children: [
              Image.network(
                widget.product['imagepath'],
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Center(
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          ),
                width: double.infinity,
                height: size.height * 0.22,
                errorBuilder: ((context, error, stackTrace) => Center(
                      child: Image.asset(
                          'assets/Error_images/3d-render-red-paper-clipboard-with-cross-mark.jpg',
                          fit: BoxFit.fitHeight),
                    )),
                fit: BoxFit.cover,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/productDetail', arguments: widget.product);
                  },
                  splashColor: primaryColor.withOpacity(0.1),
                ),
              )
            ]),
            Positioned(
              left: 10,
              child: Chip(
                label: Text(widget.product['title']),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            )
          ]),
        ),
      ),
      SizedBox(
        height: size.height * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(uid)
                    .collection('Orders')
                    .doc(id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return HeartbeatProgressIndicator(child: const Icon(Icons.shopping_basket_outlined));
                  } else if (snapshot.hasError) {
                    return GlowingProgressIndicator(child: const Icon(Icons.shopping_basket_outlined));
                  }
                  return IconButton(
                      icon: snapshot.data!.exists
                          ? const Icon(Icons.shopping_basket)
                          : const Icon(Icons.shopping_basket_outlined),
                      onPressed: () async {
                        provider.toggler(
                          widget.product,
                          uid,
                          'Orders',
                          1,
                          context,
                          'Added to cart',
                          'Removed from cart',
                        );
                      });
                }),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(uid)
                    .collection('Favourites')
                    .doc(id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return HeartbeatProgressIndicator(child: const Icon(Icons.favorite_border_rounded));
                  } else if (snapshot.hasError) {
                    return GlowingProgressIndicator(child: const Icon(Icons.favorite_border_rounded));
                  }
                  return IconButton(
                    icon: snapshot.data!.exists
                        ? const Icon(Icons.favorite_rounded)
                        : const Icon(Icons.favorite_border_rounded),
                    onPressed: () async {
                      provider.toggler(
                        widget.product,
                        uid,
                        'Favourites',
                        1,
                        context,
                        'Added to favourites',
                        'Removed from favourites',
                      );
                    },
                  );
                }),
          ],
        ),
      )
    ]);
  }
}
