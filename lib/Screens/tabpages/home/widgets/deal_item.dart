import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Provider/item_provider..dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';

import '../../../../Constants/colors.dart';
import '../../../../Utils/snack_bar.dart';

class DealItem extends StatelessWidget {
  const DealItem({Key? key, required this.product}) : super(key: key);
  final QueryDocumentSnapshot product;
  @override
  Widget build(BuildContext context) {
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
              Image.network(
                product['imagepath'],
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
                        .pushNamed('/productDetail', arguments: product);
                  },
                  splashColor: primaryColor.withOpacity(0.1),
                ),
              )
            ]),
            Positioned(
              left: 10,
              child: Chip(
                label: Text(product['title']),
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
            IconButton(
              icon: product['isCarted'] == true
                  ? const Icon(Icons.shopping_basket)
                  : const Icon(Icons.shopping_basket_outlined),
              onPressed: () async {
                print(product.id);
                await Provider.of<Itemprovider>(context, listen: false)
                    .addtoCarts(product, uid)
                    .then((value) {
                  if (product['isCarted'] == false) {
                    final SnackBar showSnackBar =
                        snackBar('Added to your Cart', 2);
                    ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
                  } else if (product['isCarted'] == true) {
                    final SnackBar showSnackBar =
                        snackBar('Removed from Cart', 2);
                    ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
                  } else {
                    final SnackBar showSnackBar = snackBar('Error', 2);
                    ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
                  }
                });
              },
            ),
            IconButton(
              icon: product['isFavourited'] == true
                  ? const Icon(Icons.favorite_rounded)
                  : const Icon(Icons.favorite_border_rounded),
              onPressed: () async {
                Provider.of<Itemprovider>(context, listen: false)
                    .addtoFavourites(product, uid)
                    .then((value) {
                  if (product['isFavourited'] == false) {
                    final SnackBar showSnackBar =
                        snackBar('Added to favourites', 2);
                    ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
                  } else if (product['isCarted'] == true) {
                    final SnackBar showSnackBar =
                        snackBar('Removed from favourites', 2);
                    ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
                  } else {
                    final SnackBar showSnackBar = snackBar('Error', 2);
                    ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
                  }
                });
              },
            ),
          ],
        ),
      ),
    ]);
  }
}
