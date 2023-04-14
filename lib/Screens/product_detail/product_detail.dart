import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Utils/other_methods.dart';
import 'package:farmsies/Widgets/generalwidget/confirmation_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

import '../../Constants/colors.dart';
import '../../Provider/item_provider..dart';
import '../../Utils/snack_bar.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key, required this.productDetail})
      : super(key: key);

  final QueryDocumentSnapshot productDetail;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool toggleFavouriteMode = false;
  bool toggleCartmode = false;

  void getTogglemode() async {
    final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    final String uid = firebaseAuth.currentUser!.uid;
    toggleFavouriteMode =
        await Provider.of<Itemprovider>(context, listen: false).isToggledStatus(
      widget.productDetail,
      widget.productDetail.id,
      uid,
      'Favourites',
    );
    toggleCartmode =
        await Provider.of<Itemprovider>(context, listen: false).isToggledStatus(
      widget.productDetail,
      widget.productDetail.id,
      uid,
      'Orders',
    );
    setState(() {});
  }

  @override
  void initState() {
    getTogglemode();
    super.initState();
  }

  int itemAmount = 1;
  @override
  Widget build(BuildContext context) {
    final id = widget.productDetail.id;
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<Itemprovider>(context);
    final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    final String uid = firebaseAuth.currentUser!.uid;

    final Map<String, dynamic> product = {
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_sharp),
            onPressed: () => Navigator.pop(
                  context,
                )),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
          stream: FirebaseFirestore.instance
              .collection('Products')
              .doc(id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SizedBox(
                child: Center(
                  child: JumpingText(
                    'Error',
                    style: TextStyle(color: primaryColor),
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
                padding: const EdgeInsets.only(top: 0),
                children: [
                  Stack(children: [
                    SizedBox(
                      height: size.height * 0.5,
                      child: Hero(
                        tag: id,
                        child: FadeInImage(
                          repeat: ImageRepeat.noRepeat,
                          fadeOutDuration: const Duration(seconds: 5),
                          fadeOutCurve: Curves.bounceOut,
                          fadeInCurve: Curves.bounceIn,
                          fadeInDuration: const Duration(seconds: 5),
                          placeholder: const AssetImage('assets/harvest.png'),
                          image: NetworkImage(
                            product['imagepath'],
                          ),
                          placeholderFit: BoxFit.contain,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          imageErrorBuilder: ((context, error, stackTrace) =>
                              Center(
                                child: Image.asset(
                                    'assets/Error_images/3d-render-red-paper-clipboard-with-cross-mark.jpg',
                                    fit: BoxFit.fitHeight),
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                      right: size.width * 0.02,
                      bottom: size.height * 0.02,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.01),
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            firebaseAuth.currentUser!.email ==
                                    widget.productDetail['email']
                                ? 'Your Shop'
                                : '${widget.productDetail['itemCreator'].toString()}\'s Shop',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        height: size.height * 0.1,
                        width: size.height * 0.07,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    )
                  ]),
                  spacing(size: size, height: 0.01),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          product['title'],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .doc(uid)
                                .collection('Favourites')
                                .doc(id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return GlowingProgressIndicator(
                                    child: const Icon(
                                        Icons.favorite_border_rounded));
                              }
                              return IconButton(
                                icon: toggleFavouriteMode
                                    ? const Icon(Icons.favorite_rounded)
                                    : const Icon(Icons.favorite_border_rounded),
                                onPressed: () async {
                                  await provider
                                      .toggler(
                                          widget.productDetail,
                                          uid,
                                          'Favourites',
                                          1,
                                          context,
                                          'Added to your favourites',
                                          'Removed from your favourites')
                                      .then((value) {
                                    setState(() {
                                      toggleFavouriteMode =
                                          !toggleFavouriteMode;
                                    });
                                  });
                                },
                              );
                            })
                      ],
                    ),
                  ),
                  spacing(size: size, height: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        itemAmount <= 0
                            ? '₦ 0'
                            : 'N${product['price'] * itemAmount}',
                        style: TextStyle(fontSize: 17, color: primaryColor),
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
                                  itemAmount >= data!['amount']
                                      ? itemAmount = data['amount']
                                      : itemAmount = itemAmount + 1;
                                });
                                if (itemAmount >= data!['amount']) {
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
                                      itemAmount >= data!['amount']
                                          ? itemAmount = data['amount']
                                          : itemAmount = itemAmount + 10;
                                    });
                                    if (itemAmount >= data!['amount']) {
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
                  titles(size, 'Amount Available'),
                  spacing(size: size, height: 0.02),
                  detail(
                      size,
                      data!['amount'] >= 2
                          ? '${data['amount']} ${data['title']}\'s are availabe for now'
                          : 'Only ${data['amount']} ${data['title'].toString().toLowerCase()} is availabe for now. Check back later!🙂'),
                  spacing(size: size, height: 0.02),
                  divider(size),
                  spacing(size: size, height: 0.035),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: size.width * 1,
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .collection('Orders')
                            .doc(id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final data2 = snapshot.data;
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: JumpingText(
                              'Please wait',
                              style: TextStyle(color: primaryColor),
                            ));
                          } else if (snapshot.hasError) {
                            return Center(
                              child: JumpingText(
                                'Error',
                                style: TextStyle(color: primaryColor),
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (!snapshot.hasData || !data2!.exists) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const SizedBox(
                                    child: Icon(Icons.shopping_cart_outlined),
                                  ),
                                  firebaseAuth.currentUser!.email ==
                                          widget.productDetail['email']
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              left: size.width * 0.05),
                                          width: size.width * 0.5,
                                          height: size.height * 0.06,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              )),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      primaryColor),
                                            ),
                                            onPressed: () {
                                              final SnackBar showSnackBar =
                                                  snackBar(
                                                      'This is your item, long press for more actions',
                                                      1);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(showSnackBar);
                                            },
                                            onLongPress: () async {
                                              try {
                                                confirm(
                                                  title: 'This is your product',
                                                  content:
                                                      'What would you like to do to this product?',
                                                  onClicked1: () async {
                                                    DocumentReference
                                                        documentReference =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Products')
                                                            .doc(id);
                                                    Navigator.pop(context);
                                                    try {
                                                      await confirm(
                                                        title:
                                                            'Delete your Product?',
                                                        content:
                                                            'Are you sure you want to delete your product',
                                                        onClicked1: () =>
                                                            Navigator.pop(
                                                                context),
                                                        onClicked2: () async {
                                                          Navigator
                                                              .pushNamedAndRemoveUntil(
                                                                  context,
                                                                  '/homepage',
                                                                  (route) => false,);
                                                          await documentReference
                                                              .delete()
                                                              .then(
                                                                  (value) async {
                                                            final productImageReference =
                                                                FirebaseStorage
                                                                    .instance
                                                                    .refFromURL(
                                                                        widget.productDetail[
                                                                            'imagepath']);
                                                            await productImageReference
                                                                .delete()
                                                                .then((value) =>
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      snackBar(
                                                                          'Your item has been deleted successfully',
                                                                          1),
                                                                    ));
                                                          });
                                                        },
                                                        textbutton1: 'No',
                                                        textbutton2: 'Yes',
                                                        context: context,
                                                      );
                                                    } catch (e) {
                                                      print('Error');
                                                    }
                                                  },
                                                  onClicked2: () async {
                                                    itemAmount == 0 ||
                                                            itemAmount >
                                                                data['amount']
                                                        ? ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(snackBar(
                                                                'You need to have more than 0 items in your cart',
                                                                1))
                                                        : provider
                                                            .toggler(
                                                              widget
                                                                  .productDetail,
                                                              uid,
                                                              'Orders',
                                                              itemAmount,
                                                              context,
                                                              'Added to your item to cart',
                                                              'Removed from your item from cart',
                                                            )
                                                            .then((value) =>
                                                                Navigator.pop(
                                                                    context));
                                                  },
                                                  textbutton1: 'Delete',
                                                  textbutton2:
                                                      'Add your item to your cart',
                                                  context: context,
                                                );
                                              } catch (e) {
                                                print('error');
                                              }
                                            },
                                            child: const Text(
                                                'This is your product'),
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                              left: size.width * 0.05),
                                          width: size.width * 0.5,
                                          height: size.height * 0.06,
                                          child: ElevatedButton(
                                            child: itemAmount == 0 ||
                                                    itemAmount > data['amount']
                                                ? const Text('No item in cart')
                                                : const Text('Add to cart'),
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              )),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      primaryColor),
                                            ),
                                            onPressed: itemAmount == 0 ||
                                                    itemAmount > data['amount']
                                                ? null
                                                : () async {
                                                    provider.toggler(
                                                      widget.productDetail,
                                                      uid,
                                                      'Orders',
                                                      itemAmount,
                                                      context,
                                                      'Added to your cart',
                                                      'Removed from your cart',
                                                    );
                                                  },
                                          ),
                                        ),
                                ],
                              );
                            } else {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    child: data2['isCarted']
                                        ? const Icon(Icons.shopping_cart)
                                        : const Icon(
                                            Icons.shopping_cart_outlined),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: size.width * 0.05),
                                    width: size.width * 0.5,
                                    height: size.height * 0.06,
                                    child: ElevatedButton(
                                      child: data2.exists
                                          ? const Text('Remove from cart')
                                          : const Text('Add to cart'),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                primaryColor),
                                      ),
                                      onPressed: itemAmount == 0 ||
                                              itemAmount > data['amount']
                                          ? null
                                          : () async {
                                              provider.toggler(
                                                widget.productDetail,
                                                uid,
                                                'Orders',
                                                itemAmount,
                                                context,
                                                'Added to your cart',
                                                'Removed from your cart',
                                              );
                                            },
                                    ),
                                  ),
                                ],
                              );
                            }
                          } else {
                            return JumpingText('Error');
                          }
                        }),
                  ),
                  spacing(size: size, height: 0.05),
                ],
              );
            }
          }),
    );
  }

  Padding detail(Size size, String details) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.075),
      child: Text(
        details.toLowerCase(),
        textAlign: TextAlign.left,
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
      ),
    );
  }

  Divider divider(Size size) =>
      Divider(endIndent: size.width * 0.07, indent: size.width * 0.07);

  Padding titles(Size size, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.075),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 17, fontWeight: FontWeight.w500, color: primaryColor),
      ),
    );
  }
}
