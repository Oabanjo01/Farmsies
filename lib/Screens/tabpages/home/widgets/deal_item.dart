import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Provider/item_provider..dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import '../../../../Constants/colors.dart';

class DealItem extends StatefulWidget {
  const DealItem({Key? key, required this.product}) : super(key: key);
  final DocumentSnapshot product;

  @override
  State<DealItem> createState() => _DealItemState();
}

class _DealItemState extends State<DealItem> {
  bool toggleFavouriteMode = false;
  bool toggleCartmode = false;

  @override
  void didChangeDependencies() {
    getTogglemode();
    super.didChangeDependencies();
  }

  void getTogglemode() async {
    final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    final String uid = firebaseAuth.currentUser!.uid;
    toggleFavouriteMode =
        await Provider.of<Itemprovider>(context, listen: false).isToggledStatus(
      widget.product,
      widget.product.id,
      uid,
      'Favourites',
    );
    toggleCartmode =
        await Provider.of<Itemprovider>(context, listen: false).isToggledStatus(
      widget.product,
      widget.product.id,
      uid,
      'Orders',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    final size = MediaQuery.of(context).size;
    final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    final String uid = firebaseAuth.currentUser!.uid;
    return Column(children: [
      Flexible(
        fit: FlexFit.tight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(children: [
            Stack(children: [
              Hero(
                tag: widget.product.id,
                child: FadeInImage(
                    fadeOutDuration: const Duration(seconds: 2),
                    fadeInCurve: Curves.elasticIn,
                    fadeOutCurve: Curves.elasticInOut,
                    fadeInDuration: const Duration(seconds: 2),
                    placeholder: const AssetImage('assets/harvest.png'),
                    image: NetworkImage(
                      widget.product['imagepath'],
                    ),
                    placeholderFit: BoxFit.scaleDown,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    imageErrorBuilder: ((context, error, stackTrace) => Center(
                          child: Image.asset(
                              'assets/Error_images/3d-render-red-paper-clipboard-with-cross-mark.jpg',
                              fit: BoxFit.fitHeight),
                        ))),
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
                label: Text('₦${widget.product['price'].toString()}'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            )
          ]),
        ),
      ),
      SizedBox(
          height: size.height * 0.05,
          child: Consumer<Itemprovider>(
            builder: (context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: toggleCartmode
                      ? const Icon(Icons.shopping_basket)
                      : const Icon(Icons.shopping_basket_outlined),
                  onPressed: () async {
                    await value
                        .toggler(
                          widget.product,
                          uid,
                          'Orders',
                          1,
                          context,
                          'Added to cart',
                          'Removed from cart',
                        )
                        .then((value) => setState(() {
                              toggleCartmode = !toggleCartmode;
                            }));
                  },
                ),
                IconButton(
                  icon: toggleFavouriteMode
                      ? const Icon(Icons.favorite_rounded)
                      : const Icon(Icons.favorite_border_rounded),
                  onPressed: () async {
                    await value
                        .toggler(
                          widget.product,
                          uid,
                          'Favourites',
                          1,
                          context,
                          'Added to favourites',
                          'Removed from favourites',
                        )
                        .then((value) => setState(() {
                              toggleFavouriteMode = !toggleFavouriteMode;
                            }));
                    // provider.toggler(
                    //   widget.product,
                    //   uid,
                    //   'Favourites',
                    //   1,
                    //   context,
                    //   'Added to favourites',
                    //   'Removed from favourites',
                    // );
                  },
                )
              ],
            ),
          ))
    ]);
  }
}


// FutureBuilder<DocumentSnapshot>(
//                     future: null
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return GlowingProgressIndicator(
//                             child: const Icon(Icons.favorite_border_rounded));
//                       } else if (snapshot.hasError) {
//                         return GlowingProgressIndicator(
//                             child: const Icon(Icons.favorite_border_rounded));
//                       } else if (!snapshot.data!.exists) {
//                         GlowingProgressIndicator(
//                             child: const Icon(Icons.favorite_border_rounded));
//                       }
//                       return 
