import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Utils/other_methods.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import '../../Utils/snack_bar.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key, required this.productDetail})
      : super(key: key);

  final QueryDocumentSnapshot productDetail;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int itemAmount = 1;
  @override
  Widget build(BuildContext context) {
    final id = widget.productDetail.id;
    final size = MediaQuery.of(context).size;
    final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    final String uid = firebaseAuth.currentUser!.uid;
    final Map<String, dynamic> product = {
      // 'id': widget.productDetail.id,
      'title': widget.productDetail['title'] as String,
      'price': widget.productDetail['price'] as int,
      'amount': widget.productDetail['amount'] <= 1
          ? widget.productDetail['amount']
          : 0,
      'description': widget.productDetail['description'] as String,
      'imagepath': widget.productDetail['imagepath'] as String,
      'isFavourited': widget.productDetail['isFavourited'] as bool,
      'isCarted': widget.productDetail['isCarted'] as bool,
    };
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryColor,
      ),
      extendBodyBehindAppBar: true,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
          stream: FirebaseFirestore.instance
              .collection('Products')
              .doc(id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SizedBox(
                child: Center(
                  child: Text(
                    'An error occured',
                  ),
                ),
              );
            } else if (!snapshot.hasData) {
              return const SizedBox(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              final data = snapshot.data!.data();
              return ListView(
                padding: const EdgeInsets.only(
                  top: 0,
                ),
                children: [
                  SizedBox(
                    height: size.height * 0.4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      child: Image.network(
                        product['imagepath'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  spacing(size: size, height: 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product['title'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                            onPressed: () async {
                              final CollectionReference collectionReference =
                                  FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(uid)
                                      .collection('Favourites');
                              if (data!['isFavourited'] == true) {
                                await FirebaseFirestore.instance
                                    .collection('Products')
                                    .doc(id)
                                    .update({'isFavourited': false}).then(
                                        (value) async {
                                  await collectionReference.doc(id).delete();
                                  final SnackBar showSnackBar = snackBar(
                                      'Removed from your favourites', 2);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(showSnackBar);
                                });
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('Products')
                                    .doc(id)
                                    .update({'isFavourited': true}).then(
                                        (value) async {
                                  await collectionReference.doc(id).set({
                                    'id': id,
                                    'title': product['title'],
                                    'price': product['price'],
                                    'amount': product['amount'],
                                    'description': product['description'],
                                    'imagepath': product['imagepath'],
                                    'isFavourited': true,
                                    'isCarted': product['isCarted'],
                                  });
                                  final SnackBar showSnackBar =
                                      snackBar('Added to your favourites', 2);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(showSnackBar);
                                });
                              }
                            },
                            icon: Icon(
                              data!['isFavourited'] == true
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: primaryColor,
                            ))
                      ],
                    ),
                  ),
                  spacing(size: size, height: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.075),
                        child: Text(
                          itemAmount <= 0
                              ? '₦ 0'
                              : 'N${product['price'] * itemAmount}',
                          style: TextStyle(fontSize: 17, color: primaryColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: size.width * 0.025),
                        child: SizedBox(
                          child: Row(children: [
                            GestureDetector(
                              onTap: (() => setState(() {
                                    itemAmount <= 0
                                        ? itemAmount = 0
                                        : itemAmount = itemAmount - 10;
                                  })),
                              child: SizedBox(
                                child: Text(
                                  '-10',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  itemAmount <= 0
                                      ? itemAmount = 0
                                      : itemAmount = itemAmount - 1;
                                });
                              },
                              icon: Icon(
                                Icons.remove,
                                color: primaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              color: secondaryColor,
                              child: Text(
                                itemAmount <= 0 ? '0' : '$itemAmount',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? primaryColor
                                        : Colors.black),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  itemAmount >= data['amount']
                                      ? itemAmount = data['amount']
                                      : itemAmount = itemAmount + 1;
                                });
                                if (itemAmount >= data['amount']) {
                                  final SnackBar showSnackBar = snackBar(
                                      'Only ${data['amount']} available, check back later!',
                                      2);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(showSnackBar);
                                }
                              },
                              icon: Icon(Icons.add, color: primaryColor),
                            ),
                            GestureDetector(
                              onTap: (() => setState(() {
                                    // conditions to limit ordering more that the orders expected
                                    setState(() {
                                      itemAmount >= data['amount']
                                          ? itemAmount = data['amount']
                                          : itemAmount = itemAmount + 10;
                                    });
                                    if (itemAmount >= data['amount']) {
                                      final SnackBar showSnackBar = snackBar(
                                          'Only ${data['amount']} available, check back later!',
                                          2);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(showSnackBar);
                                    }
                                  })),
                              child: SizedBox(
                                child: Text(
                                  '+10',
                                  style: TextStyle(
                                      fontSize: 17, color: primaryColor),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  divider(size),
                  spacing(size: size, height: 0.01),
                  titles(size, 'Product Detail'),
                  spacing(size: size, height: 0.02),
                  detail(size, product['description']),
                  spacing(size: size, height: 0.01),
                  divider(size),
                  spacing(size: size, height: 0.02),
                  titles(size, 'Nutritions'),
                  spacing(size: size, height: 0.02),
                  detail(size, 'Details'),
                  spacing(size: size, height: 0.02),
                  divider(size),
                  spacing(size: size, height: 0.035),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: size.width * 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          child: data['isCarted']
                              ? const Icon(Icons.shopping_cart)
                              : const Icon(Icons.shopping_cart_outlined),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: size.width * 0.05),
                          width: size.width * 0.5,
                          height: size.height * 0.06,
                          child: ElevatedButton(
                            onPressed: itemAmount == 0
                                ? null
                                : () async {
                                    final CollectionReference
                                        collectionReference = FirebaseFirestore
                                            .instance
                                            .collection('Users')
                                            .doc(uid)
                                            .collection('Orders');
                                    if (data['isCarted'] == true) {
                                      await FirebaseFirestore.instance
                                          .collection('Products')
                                          .doc(id)
                                          .update({'isCarted': false}).then(
                                              (value) async {
                                        await collectionReference
                                            .doc(id)
                                            .delete();
                                        final SnackBar showSnackBar = snackBar(
                                            'Removed from your carts', 2);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(showSnackBar);
                                      });
                                    } else if (data['isCarted'] == false) {
                                      await FirebaseFirestore.instance
                                          .collection('Products')
                                          .doc(id)
                                          .update({'isCarted': true}).then(
                                              (value) async {
                                        await collectionReference.doc(id).set({
                                          'id': id,
                                          'title': product['title'],
                                          'price': product['price'],
                                          'amount': itemAmount,
                                          'description': product['description'],
                                          'imagepath': product['imagepath'],
                                          'isFavourited':
                                              product['isFavourited'],
                                          'isCarted': true,
                                        });
                                        final SnackBar showSnackBar =
                                            snackBar('Carted', 2);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(showSnackBar);
                                      });
                                    } else {
                                      final SnackBar showSnackBar =
                                          snackBar('Error', 2);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(showSnackBar);
                                    }
                                  },
                            child: data['isCarted']
                                ? const Text('Remove from cart')
                                : const Text('Add to cart'),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all(primaryColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }

  Padding detail(Size size, String details) {
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.075),
      child: Text(
        details,
        textAlign: TextAlign.left,
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
      ),
    );
  }

  Divider divider(Size size) =>
      Divider(endIndent: size.width * 0.07, indent: size.width * 0.07);

  Padding titles(Size size, String title) {
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.075),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 17, fontWeight: FontWeight.w500, color: primaryColor),
      ),
    );
  }
}
