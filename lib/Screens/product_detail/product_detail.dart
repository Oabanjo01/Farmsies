import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Screens/tabpages/favourites/widgets/list_view.dart';
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
  bool _isVisible = false;

  TextEditingController commentController = TextEditingController();
  TextEditingController subCommentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _subCommentscrollController = ScrollController();

  final GlobalKey<FormState> _globalKey = GlobalKey();
  final GlobalKey<FormState> _globalKey2 = GlobalKey();
  bool toggleFavouriteMode = false;
  int itemInList = -1;
  bool toggleCartmode = false;
  final List<Map<String, String>> items = [
    {'title': 'Item 1', 'description': 'description 1'},
    {
      'title': 'Item 2 that I am using to test longer words',
      'description': 'description 2'
    }
  ];

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
    if (mounted) {
      toggleCartmode = await Provider.of<Itemprovider>(context, listen: false)
          .isToggledStatus(
        widget.productDetail,
        widget.productDetail.id,
        uid,
        'Orders',
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getTogglemode();
  }

  @override
  void dispose() {
    commentController.dispose();
    subCommentController.dispose();
    _scrollController.dispose();
    _subCommentscrollController.dispose();
    super.dispose();
  }

  int itemAmount = 1;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness;
    final id = widget.productDetail.id;
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<Itemprovider>(context);
    final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    final String uid = firebaseAuth.currentUser!.uid;
    final String? email = firebaseAuth.currentUser!.email;
    final String? userPost = firebaseAuth.currentUser!.displayName;

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
            icon: Icon(Icons.arrow_back, color: primaryColor),
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
            if (snapshot.hasData) {
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
                          fadeOutDuration: const Duration(seconds: 1),
                          fadeOutCurve: Curves.bounceOut,
                          fadeInCurve: Curves.bounceIn,
                          fadeInDuration: const Duration(seconds: 1),
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
                        height: size.height * 0.1,
                        width: size.height * 0.07,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme == Brightness.dark
                                ? screenDarkColor
                                : screenColor),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            firebaseAuth.currentUser!.email ==
                                    widget.productDetail['email']
                                ? 'Your Shop'
                                : '${widget.productDetail['itemCreator'].toString()}\'s Shop',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
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
                          product['title'].toString().capitalize(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
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
                                color: Theme.of(context).iconTheme.color,
                                icon: toggleFavouriteMode
                                    ? Icon(Icons.favorite_rounded,
                                        color: errorColor)
                                    : Icon(
                                        Icons.favorite_border_rounded,
                                        color: errorColor,
                                      ),
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
                  Divider(
                      color: primaryColor,
                      endIndent: size.width * 0.3,
                      indent: size.width * 0.3),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      itemAmount <= 0
                          ? '₦0'
                          : '₦${product['price'] * itemAmount}',
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Divider(
                      color: primaryColor,
                      endIndent: size.width * 0.3,
                      indent: size.width * 0.3),
                  spacing(size: size, height: 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: size.width * 0.025),
                        child: SizedBox(
                          child: Row(children: [
                            TextButton(
                              style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                          const CircleBorder()),
                                  side: MaterialStateProperty.all<BorderSide>(
                                      BorderSide(
                                    width: 0.5,
                                    color: theme == Brightness.dark
                                        ? screenColor
                                        : screenDarkColor,
                                  ))),
                              onPressed: () => setState(() {
                                itemAmount <= 0
                                    ? itemAmount = 0
                                    : itemAmount = itemAmount - 10;
                              }),
                              child: Text(
                                '-10',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            OutlinedButton(
                              style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                          const CircleBorder()),
                                  side: MaterialStateProperty.all<BorderSide>(
                                      BorderSide(
                                    width: 0.5,
                                    color: theme == Brightness.dark
                                        ? screenColor
                                        : screenDarkColor,
                                  ))),
                              onPressed: () {
                                setState(() {
                                  itemAmount <= 0
                                      ? itemAmount = 0
                                      : itemAmount = itemAmount - 1;
                                });
                              },
                              child: Icon(
                                Icons.remove,
                                color: primaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: theme == Brightness.dark
                                      ? Colors.black.withOpacity(0.3)
                                      : secondaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text(
                                itemAmount <= 0 ? '0' : '$itemAmount',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: theme == Brightness.dark
                                        ? primaryColor
                                        : Colors.black),
                              ),
                            ),
                            OutlinedButton(
                              style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                          const CircleBorder()),
                                  side: MaterialStateProperty.all<BorderSide>(
                                      BorderSide(
                                    width: 0.5,
                                    color: theme == Brightness.dark
                                        ? screenColor
                                        : screenDarkColor,
                                  ))),
                              onPressed: () {
                                setState(() {
                                  itemAmount >= data!['amount']
                                      ? itemAmount = data['amount']
                                      : itemAmount = itemAmount + 1;
                                });
                                if (itemAmount >= data!['amount']) {
                                  final SnackBar showSnackBar = snackBar(
                                      context,
                                      'Only ${data['amount']} available, check back later!',
                                      2);
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(showSnackBar);
                                }
                              },
                              child: Icon(Icons.add, color: primaryColor),
                            ),
                            SizedBox(
                              child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(const CircleBorder()),
                                    side: MaterialStateProperty.all<BorderSide>(
                                        BorderSide(
                                      width: 0.5,
                                      color: theme == Brightness.dark
                                          ? screenColor
                                          : screenDarkColor,
                                    ))),
                                onPressed: () => setState(() {
                                  // conditions to limit ordering more that the orders expected
                                  setState(() {
                                    itemAmount >= data!['amount']
                                        ? itemAmount = data['amount']
                                        : itemAmount = itemAmount + 10;
                                  });
                                  if (itemAmount >= data!['amount']) {
                                    final SnackBar showSnackBar = snackBar(
                                        context,
                                        'Only ${data['amount']} available, check back later!',
                                        2);
                                    ScaffoldMessenger.of(context)
                                      ..removeCurrentSnackBar()
                                      ..showSnackBar(showSnackBar);
                                  }
                                }),
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
                  detail(size, product['description'].toString()),
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
                          final data1 = snapshot.data;

                          if (!snapshot.hasData || !data1!.exists) {
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
                                        child: provider.toggled == true
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : ElevatedButton(
                                                style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  )),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          theme ==
                                                                  Brightness
                                                                      .light
                                                              ? textColor
                                                              : textDarkColor),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          primaryColor),
                                                ),
                                                onPressed: () {
                                                  final SnackBar showSnackBar =
                                                      snackBar(
                                                          context,
                                                          'This is your item, long press for more actions',
                                                          1);
                                                  ScaffoldMessenger.of(context)
                                                    ..removeCurrentSnackBar()
                                                    ..showSnackBar(
                                                        showSnackBar);
                                                },
                                                onLongPress: () async {
                                                  try {
                                                    confirm(
                                                      title:
                                                          'This is your product',
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
                                                            onClicked2:
                                                                () async {
                                                              Navigator
                                                                  .pushNamedAndRemoveUntil(
                                                                context,
                                                                '/homepage',
                                                                (route) =>
                                                                    false,
                                                              );
                                                              await documentReference
                                                                  .delete()
                                                                  .then(
                                                                      (value) async {
                                                                final productImageReference =
                                                                    FirebaseStorage
                                                                        .instance
                                                                        .refFromURL(
                                                                            widget.productDetail['imagepath']);
                                                                await productImageReference
                                                                    .delete()
                                                                    .then((value) =>
                                                                        ScaffoldMessenger.of(
                                                                            context)
                                                                          ..removeCurrentSnackBar()
                                                                          ..showSnackBar(
                                                                            snackBar(
                                                                                context,
                                                                                'Your item has been deleted successfully',
                                                                                1),
                                                                          ));
                                                              });
                                                            },
                                                            textbutton1: 'No',
                                                            textbutton2: 'Yes',
                                                            context: context,
                                                          );
                                                        } catch (e) {}
                                                      },
                                                      onClicked2: () async {
                                                        itemAmount == 0 ||
                                                                itemAmount >
                                                                    data[
                                                                        'amount']
                                                            ? ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackBar(
                                                                        context,
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
                                                  } catch (e) {}
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
                                        child: provider.toggled == true
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : ElevatedButton(
                                                style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  )),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          theme ==
                                                                  Brightness
                                                                      .light
                                                              ? textColor
                                                              : textDarkColor),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          primaryColor),
                                                ),
                                                onPressed: itemAmount == 0 ||
                                                        itemAmount >
                                                            data['amount']
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
                                                child: itemAmount == 0 ||
                                                        itemAmount >
                                                            data['amount']
                                                    ? Text('No item in cart',
                                                        style: TextStyle(
                                                            color: theme ==
                                                                    Brightness
                                                                        .light
                                                                ? textColor
                                                                : textDarkColor))
                                                    : Text(
                                                        'Add to cart',
                                                        style: TextStyle(
                                                            color: theme ==
                                                                    Brightness
                                                                        .light
                                                                ? textColor
                                                                : textDarkColor),
                                                      ),
                                              ),
                                      ),
                              ],
                            );
                          } else if (snapshot.hasData) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  child: data1['isCarted']
                                      ? const Icon(Icons.shopping_cart)
                                      : const Icon(
                                          Icons.shopping_cart_outlined),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: size.width * 0.05),
                                  width: size.width * 0.5,
                                  height: size.height * 0.06,
                                  child: provider.toggled == true
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ElevatedButton(
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
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      theme == Brightness.light
                                                          ? textColor
                                                          : textDarkColor)),
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
                                          child: data1.exists
                                              ? const Text('Remove from cart')
                                              : const Text('Add to cart'),
                                        ),
                                ),
                              ],
                            );
                          } else if (snapshot.connectionState ==
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
                          } else {
                            return JumpingText('Error');
                          }
                        }),
                  ),
                  spacing(size: size, height: 0.05),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.075 / 2),
                    child: ExpansionTile(
                      onExpansionChanged: (value) {
                        if (value == true) {
                          final SnackBar showSnackBar = snackBar(
                              context,
                              'Longpress chatboxes to Reply or Like comment. Tap the comments to remove the \'Like\' and \'Reply\' option',
                              4);
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(showSnackBar);
                        }
                        return;
                      },
                      childrenPadding: EdgeInsets.only(top: size.height * 0.01),
                      title: const Text(
                        'Comments and Posts',
                      ),
                      children: <Widget>[
                        InkWell(
                          splashFactory: NoSplash.splashFactory,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            print(id);
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          child: SizedBox(
                            height: size.height * 0.62,
                            width: double.infinity,
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                StreamBuilder<
                                        QuerySnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Products')
                                        .doc(id)
                                        .collection('Comments')
                                        .orderBy('time', descending: false)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      final List data2 =
                                          snapshot.data?.docs ?? [];
                                      if (snapshot.hasData) {
                                        if (data2.isEmpty) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: primaryColor
                                                        .withOpacity(0.4),
                                                    width: 1)),
                                            height: size.height * 0.3,
                                            child: const Center(
                                              child: Text(
                                                  'No comment has been made on this post'),
                                            ),
                                          );
                                        }
                                        return Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: primaryColor
                                                        .withOpacity(0.4),
                                                    width: 1)),
                                            height: size.height * 0.5,
                                            padding: const EdgeInsets.all(10),
                                            child: ListView.separated(
                                                controller: _scrollController,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount: data2.length,
                                                padding: EdgeInsets.zero,
                                                separatorBuilder: (context,
                                                        index) =>
                                                    SizedBox(
                                                        height:
                                                            size.height * 0.01),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return Align(
                                                    alignment: data2[index]
                                                                ['email'] ==
                                                            email
                                                        ? Alignment.topRight
                                                        : Alignment.topLeft,
                                                    child: FittedBox(
                                                      child: Column(
                                                        crossAxisAlignment: data2[
                                                                        index]
                                                                    ['email'] ==
                                                                email
                                                            ? CrossAxisAlignment
                                                                .end
                                                            : CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                data2[index][
                                                                            'email'] ==
                                                                        email
                                                                    ? Container(
                                                                        alignment:
                                                                            Alignment.topRight,
                                                                        child: userComment(
                                                                            userPost: data2[index][
                                                                                'postedBy'],
                                                                            data:
                                                                                data2,
                                                                            index:
                                                                                index,
                                                                            email:
                                                                                email,
                                                                            size:
                                                                                size,
                                                                            date:
                                                                                data2[index]['date'],
                                                                            id: id,
                                                                            time: data2[index]['time'],
                                                                            theme: theme),
                                                                      )
                                                                    : userAvatar(
                                                                        data2,
                                                                        index,
                                                                        email,
                                                                        theme),
                                                                const SizedBox(
                                                                    width: 8),
                                                                data2[index][
                                                                            'email'] ==
                                                                        email
                                                                    ? Container(
                                                                        child: userAvatar(
                                                                            data2,
                                                                            index,
                                                                            email,
                                                                            theme),
                                                                      )
                                                                    : userComment(
                                                                        userPost:
                                                                            data2[index]['postedBy'],
                                                                        data:
                                                                            data2,
                                                                        index:
                                                                            index,
                                                                        email:
                                                                            email,
                                                                        size:
                                                                            size,
                                                                        date: data2[index]
                                                                            [
                                                                            'date'],
                                                                        id: id,
                                                                        time: data2[index]
                                                                            [
                                                                            'time'],
                                                                        theme:
                                                                            theme,
                                                                      ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }));
                                      } else if (snapshot.hasError) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: primaryColor
                                                      .withOpacity(0.4),
                                                  width: 1)),
                                          height: size.height * 0.3,
                                          child: const Center(
                                            child:
                                                Text('No internet connnection'),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: primaryColor
                                                      .withOpacity(0.4),
                                                  width: 1)),
                                          height: size.height * 0.3,
                                          child: Center(
                                            child: JumpingText(
                                              'Fetching comments...',
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: size.height * 0.01,
                                      left: 10,
                                      right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        flex: 7,
                                        child: Form(
                                          key: _globalKey,
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.multiline,
                                            validator: ((String? value) {
                                              if (value!.length <= 1 ||
                                                  value.isEmpty) {
                                                return 'Your comment should be more than a letter.';
                                              }
                                              return null;
                                            }),
                                            onSaved: (newValue) {
                                              commentController.text =
                                                  newValue!;
                                            },
                                            controller: commentController,
                                            decoration: const InputDecoration(
                                                labelStyle: TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                                labelText: 'Write a message'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: size.width * 0.1,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: FittedBox(
                                          alignment: Alignment.center,
                                          child: IconButton(
                                            iconSize: 30,
                                            icon: const Icon(
                                              Icons.add_comment_rounded,
                                            ),
                                            onPressed: () async {
                                              if (!_globalKey.currentState!
                                                      .validate() &&
                                                  commentController
                                                      .text.isEmpty) {
                                                return;
                                              } else {
                                                DateTime now = DateTime.now();
                                                String date = DateTime.now()
                                                    .toIso8601String()
                                                    .split('T')
                                                    .first;
                                                String period =
                                                    now.hour < 12 ? 'AM' : 'PM';
                                                int hour = now.hour > 12
                                                    ? now.hour - 12
                                                    : now.hour;
                                                String time =
                                                    '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}$period';
                                                await FirebaseFirestore.instance
                                                    .collection('Products')
                                                    .doc(id)
                                                    .collection('Comments')
                                                    .doc('$email-$time-$date')
                                                    .set({
                                                  'postedBy': userPost,
                                                  'email': email,
                                                  'date': date,
                                                  'time': time,
                                                  'comment':
                                                      commentController.text
                                                }).then((value) {
                                                  commentController.clear();
                                                  _scrollController.jumpTo(
                                                      _scrollController.position
                                                          .maxScrollExtent);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  spacing(size: size, height: 0.03),
                ],
              );
            }
            if (snapshot.hasError) {
              return SizedBox(
                child: Center(
                  child: JumpingText(
                    'Error',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                child: Center(
                  child: JumpingText(
                    'Loading',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              );
            } else if (!snapshot.hasData) {
              return SizedBox(
                child: Center(
                  child: JumpingText(
                    'No data available',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              );
            } else {
              return const SizedBox(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }

  Column userComment(
      {required List<dynamic> data,
      required int index,
      String? email,
      required Size size,
      required String id,
      required String time,
      required String date,
      required String userPost,
      required Brightness theme}) {
    final String commentId = '$email-$time-$date';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: data[index]['email'] == email
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: data[index]['email'] == email
                ? Alignment.topRight
                : Alignment.topLeft,
            child: commentName(data, index)),
        InkWell(
          onTap: () {
            setState(() {
              itemInList = -1;
            });
          },
          onLongPress: () {
            setState(() {
              itemInList = index;
            });
          },
          child: commentBox(data, index, email, size),
        ),
        Visibility(
          visible: itemInList == index ? true : false,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  child: Text(
                    'Reply',
                    style: TextStyle(
                      color:
                          theme == Brightness.dark ? textDarkColor : textColor,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    print(commentId);
                  },
                  icon: Icon(
                    Icons.auto_awesome,
                    color: errorColor,
                  ),
                  label: Text(
                    'Like',
                    style: TextStyle(
                      color:
                          theme == Brightness.dark ? textDarkColor : textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isVisible,
          child: itemInList == index
              ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('Products')
                      .doc(id)
                      .collection('Comments')
                      .doc(commentId)
                      .collection('Subcomments')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final List data3 = snapshot.data!.docs;
                      if (data3.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: size.height * 0.1,
                              maxWidth: size.width * 0.5,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                    child: subcommenttextfield(
                                        commentId: commentId,
                                        email: email.toString(),
                                        id: id,
                                        index: index,
                                        size: size,
                                        userPost: data3[index]['postedBy'])),
                                const Text(
                                  'No reply yet, add yours',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container(
                        constraints: BoxConstraints(
                          minHeight: size.height * 0.1,
                          maxHeight: size.height * 0.5,
                          maxWidth: size.width * 0.5,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ListView.builder(
                                controller: _subCommentscrollController,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: data3.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: size.width * 0.5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                        commentName(data3, index),
                                        commentBox(data3, index, email, size),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        userAvatar(data3, index, email, theme),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            subcommenttextfield(
                                commentId: commentId,
                                email: email.toString(),
                                id: id,
                                index: index,
                                size: size,
                                userPost: userPost)
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Container(
                        margin: const EdgeInsets.only(left: 20),
                        alignment: Alignment.center,
                        child: LimitedBox(
                            child: JumpingText(
                          'Loading ...',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        )),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 20),
                        child: LimitedBox(
                            child: Text(
                          'Error',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: errorColor),
                        )),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 20),
                        child: LimitedBox(
                            child: JumpingText(
                          'Loading ...',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        )),
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 20),
                        child: LimitedBox(
                            child: Text(
                          'Something went wrong',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: errorColor),
                        )),
                      );
                    }
                  },
                )
              : const LimitedBox(),
        )
      ],
    );
  }

  Text commentName(List<dynamic> data, int index) {
    return Text(
        widget.productDetail['itemCreator'] == data[index]['postedBy']
            ? '${widget.productDetail['itemCreator']}(item-owner)'
            : '${data[index]['postedBy']}',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        softWrap: true,
        style: TextStyle(
          fontStyle:
              widget.productDetail['itemCreator'] == data[index]['postedBy']
                  ? FontStyle.italic
                  : FontStyle.normal,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ));
  }

  Row subcommenttextfield({
    required Size size,
    required String id,
    required String email,
    required String userPost,
    required int index,
    required String commentId,
  }) {
    return Row(
      children: [
        Flexible(
            child: Form(
          key: _globalKey2,
          child: TextFormField(
            controller: subCommentController,
            keyboardType: TextInputType.multiline,
            validator: ((String? value1) {
              if (value1!.isEmpty) {
                return 'Your comment cannot be empty';
              } else if (value1.length <= 1) {
                return 'Your comment should be more than a letter.';
              }
              return null;
            }),
            onSaved: (newValue) {
              subCommentController.text = newValue!;
            },
            decoration: const InputDecoration(
                labelText: 'Send a reply',
                labelStyle: TextStyle(fontStyle: FontStyle.italic)),
          ),
        )),
        const SizedBox(
          width: 10,
        ),
        Container(
            alignment: Alignment.center,
            width: size.width * 0.1,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
                onPressed: () async {
                  print(subCommentController.text);
                  try {
                    if (!_globalKey2.currentState!.validate()) {
                      return;
                    } else {
                      DateTime now = DateTime.now();
                      String date =
                          DateTime.now().toIso8601String().split('T').first;
                      String period = now.hour < 12 ? 'AM' : 'PM';
                      int hour = now.hour > 12 ? now.hour - 12 : now.hour;
                      String time =
                          '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}$period';
                      await FirebaseFirestore.instance
                          .collection('Products')
                          .doc(id)
                          .collection('Comments')
                          .doc(commentId)
                          .collection('Subcomments')
                          .doc('$email-$time-$date')
                          .set({
                        'postedBy': userPost,
                        'email': email,
                        'date': date,
                        'time': time,
                        'comment': subCommentController.text
                      }).then((value) {
                        subCommentController.clear();
                        _subCommentscrollController.jumpTo(
                            _subCommentscrollController
                                .position.maxScrollExtent);
                      });
                    }
                  } catch (e) {}
                },
                icon: const Icon(Icons.add_comment_rounded)))
      ],
    );
  }

  Container commentBox(
      List<dynamic> data, int index, String? email, Size size) {
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: data[index]['email'] == email ? 2 : 1),
        decoration: ShapeDecoration(
            color: primaryColor.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: const Radius.circular(20),
                bottomRight: const Radius.circular(20),
                topLeft: Radius.circular(
                  data[index]['email'] == email ? 20 : 0,
                ),
                topRight: Radius.circular(
                  data[index]['email'] == email ? 0 : 20,
                ),
              ),
            )),
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: data[index]['email'] == email
                ? size.width * 0.025
                : size.width * 0.02),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.only(right: size.width * 0.01),
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.42,
                  minWidth: size.width * 0.1,
                ),
                child: Text(
                  data[index]['comment'].toString().capitalize(),
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.blue,
              alignment: Alignment.bottomRight,
              child: Text(
                data[index]['time'].toString().substring(0, 5),
                style: const TextStyle(fontSize: 9),
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.visible,
              ),
            )
          ],
        ));
  }

  CircleAvatar userAvatar(
      List<dynamic> data2, int index, String? email, Brightness theme) {
    return CircleAvatar(
      backgroundColor: data2[index]['email'] == email
          ? primaryColor
          : widget.productDetail['itemCreator'] == data2[index]['postedBy']
              ? Colors.teal[300]
              : Colors.blue,
      foregroundColor: data2[index]['email'] == email
          ? theme == Brightness.dark
              ? textDarkColor
              : textColor
          : Colors.white,
      child: Text(
        data2[index]['postedBy'].toString().substring(0, 1),
      ),
    );
  }

  Padding detail(Size size, String details) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.075),
      child: Text(
        details.toString().capitalize(),
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

extension MyExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

// if (snapshot.connectionState ==
                                        //     ConnectionState.waiting) {
                                        //   return Expanded(
                                        //     child: Container(
                                        //       decoration: BoxDecoration(
                                        //           borderRadius:
                                        //               BorderRadius.circular(10),
                                        //           border: Border.all(
                                        //               color: primaryColor
                                        //                   .withOpacity(0.4),
                                        //               width: 1)),
                                        //       height: size.height * 0.3,
                                        //       child: Center(
                                        //         child: JumpingText(
                                        //             'Fetching comments...'),
                                        //       ),
                                        //     ),
                                        //   );
                                        // } else
                                        //  if (snapshot.hasError) {
                                        //   return Expanded(
                                        //     child: Container(
                                        //       decoration: BoxDecoration(
                                        //           borderRadius:
                                        //               BorderRadius.circular(10),
                                        //           border: Border.all(
                                        //               color: primaryColor
                                        //                   .withOpacity(0.4),
                                        //               width: 1)),
                                        //       height: size.height * 0.3,
                                        //       child: const Center(
                                        //         child: Text(
                                        //             'No internet connnection'),
                                        //       ),
                                        //     ),
                                        //   );
                                        // } else {
                                        //   if (data2.isEmpty) {
                                        //     return Expanded(
                                        //       child: Container(
                                        //         decoration: BoxDecoration(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     10),
                                        //             border: Border.all(
                                        //                 color: primaryColor
                                        //                     .withOpacity(0.4),
                                        //                 width: 1)),
                                        //         child: const Center(
                                        //           child:
                                        //               Text('No comments yet'),
                                        //         ),
                                        //       ),
                                        //     );
                                        //   }
                                        //   return Container(
                                        //     decoration: BoxDecoration(
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         border: Border.all(
                                        //             color: primaryColor
                                        //                 .withOpacity(0.4),
                                        //             width: 1)),
                                        //     height: size.height * 0.35,
                                        //     padding: const EdgeInsets.all(10),
                                        //     child: ListView.separated(
                                        //       physics:
                                        //           const BouncingScrollPhysics(),
                                        //       itemCount: data2.length,
                                        //       padding: EdgeInsets.zero,
                                        //       separatorBuilder:
                                        //           (context, index) => SizedBox(
                                        //               height:
                                        //                   size.height * 0.01),
                                        //       shrinkWrap: true,
                                        //       itemBuilder: (context, index) {
                                        //         return Align(
                                        //           alignment: data2[index]
                                        //                       ['email'] ==
                                        //                   email
                                        //               ? Alignment.topRight
                                        //               : Alignment.topLeft,
                                        //           child: FittedBox(
                                        //             child: Column(
                                        //               crossAxisAlignment: data2[
                                        //                               index]
                                        //                           ['email'] ==
                                        //                       email
                                        //                   ? CrossAxisAlignment
                                        //                       .end
                                        //                   : CrossAxisAlignment
                                        //                       .start,
                                        //               children: [
                                        //                 Visibility(
                                        //                   visible: _isVisible,
                                        //                   child: Container(
                                        //                     alignment: data2[
                                        //                                     index]
                                        //                                 [
                                        //                                 'email'] ==
                                        //                             email
                                        //                         ? Alignment
                                        //                             .centerRight
                                        //                         : Alignment
                                        //                             .centerLeft,
                                        //                     width:
                                        //                         size.width * 0.4,
                                        //                     child: Padding(
                                        //                       padding: data2[index]
                                        //                                   [
                                        //                                   'email'] !=
                                        //                               email
                                        //                           ? EdgeInsets.only(
                                        //                               left: size
                                        //                                       .width *
                                        //                                   0.05, bottom: 5)
                                        //                           : EdgeInsets.only(
                                        //                               right: size
                                        //                                       .width *
                                        //                                   0.05, bottom: 5),
                                        //                       child: Text(
                                        //                           '${data2[index]['postedBy']}',
                                        //                           overflow:
                                        //                               TextOverflow
                                        //                                   .ellipsis,
                                        //                           maxLines: 1,
                                        //                           softWrap: true,
                                        //                           style:
                                        //                               const TextStyle(
                                        //                                   fontSize:
                                        //                                       12)),
                                        //                     ),
                                        //                   ),
                                        //                 ),
                                        //                 Container(
                                        //                   alignment: Alignment
                                        //                       .bottomLeft,
                                        //                   child: Row(
                                        //                     crossAxisAlignment: CrossAxisAlignment.start,
                                        //                     children: [
                                        //                       CircleAvatar(
                                        //                         backgroundColor: data2[index]
                                        //                                     [
                                        //                                     'email'] ==
                                        //                                 email
                                        //                             ? primaryColor
                                        //                             : randomBackgroundColor,
                                        //                         foregroundColor: data2[index]
                                        //                                     [
                                        //                                     'email'] ==
                                        //                                 email
                                        //                             ? theme ==
                                        //                                     Brightness.dark
                                        //                                 ? textDarkColor
                                        //                                 : textColor
                                        //                             : randomForegroundColor,
                                        //                         child: Text(
                                        //                           data2[index][
                                        //                                   'postedBy']
                                        //                               .toString()
                                        //                               .substring(
                                        //                                   0, 1),
                                        //                         ),
                                        //                       ),
                                        //                       const SizedBox(
                                        //                           width: 8),
                                        //                       Column(
                                        //                         mainAxisSize: MainAxisSize.min,
                                        //                         crossAxisAlignment: CrossAxisAlignment.start,
                                        //                         mainAxisAlignment: MainAxisAlignment.start,
                                        //                         children: [
                                        //                           InkWell(
                                        //                             onLongPress: () {
                                        //                               setState(() {
                                        //                                 _isVisible = !_isVisible;
                                        //                               });
                                        //                             },
                                        //                             child: Container(
                                        //                                 margin: EdgeInsets.symmetric(
                                        //                                     vertical: data2[index]['email'] ==
                                        //                                             email
                                        //                                         ? 2
                                        //                                         : 0),
                                        //                                 constraints:
                                        //                                     BoxConstraints(
                                        //                                   maxWidth:
                                        //                                       size.width *
                                        //                                           0.55,
                                        //                                 ),
                                        //                                 decoration:
                                        //                                     ShapeDecoration(
                                        //                                         color: primaryColor.withOpacity(
                                        //                                             0.5),
                                        //                                         shape:
                                        //                                             RoundedRectangleBorder(
                                        //                                           borderRadius:
                                        //                                               BorderRadius.only(
                                        //                                             bottomLeft: const Radius.circular(20),
                                        //                                             bottomRight: const Radius.circular(20),
                                        //                                             topLeft: Radius.circular(
                                        //                                               data2[index]['email'] == email ? 20 : 0,
                                        //                                             ),
                                        //                                             topRight: Radius.circular(
                                        //                                               data2[index]['email'] == email ? 0 : 20,
                                        //                                             ),
                                        //                                           ),
                                        //                                         )),
                                        //                                 padding: EdgeInsets.symmetric(
                                        //                                     horizontal:
                                        //                                         size.width *
                                        //                                             0.06,
                                        //                                     vertical: data2[index]['email'] ==
                                        //                                             email
                                        //                                         ? size.width *
                                        //                                             0.028
                                        //                                         : size.width *
                                        //                                             0.02),
                                        //                                 alignment:
                                        //                                     Alignment
                                        //                                         .centerLeft,
                                        //                                 child: Text(
                                        //                                   data2[index]
                                        //                                           [
                                        //                                           'comment']
                                        //                                       .toString(),
                                        //                                   softWrap:
                                        //                                       true,
                                        //                                   style:
                                        //                                       const TextStyle(
                                        //                                     fontSize:
                                        //                                         13,
                                        //                                   ),
                                        //                                 )),
                                        //                           ),

                                        //                 FittedBox(
                                        //                   fit: BoxFit.scaleDown,
                                        //                   child: Row(
                                        //                     mainAxisSize: MainAxisSize.min,
                                        //                     children: [
                                        //                       TextButton(onPressed: () {}, child: const Text('Reply'),),
                                        //                       TextButton.icon(onPressed: () {}, icon: const Icon(Icons.auto_awesome), label: const Text('Like'))
                                        //                     ],
                                        //                   ),
                                        //                 )
                                        //                         ],
                                        //                       ),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //                 Visibility(
                                        //                   visible: _isVisible,
                                        //                   child: Container(
                                        //                     alignment: data2[
                                        //                                     index]
                                        //                                 [
                                        //                                 'email'] ==
                                        //                             email
                                        //                         ? Alignment
                                        //                             .centerRight
                                        //                         : Alignment
                                        //                             .centerLeft,
                                        //                     constraints:
                                        //                         BoxConstraints(
                                        //                             minWidth: size
                                        //                                     .width *
                                        //                                 0.2,
                                        //                             maxWidth:
                                        //                                 size.width *
                                        //                                     0.5),
                                        //                     child: Padding(
                                        //                       padding: data2[index]
                                        //                                   [
                                        //                                   'email'] ==
                                        //                               email
                                        //                           ? EdgeInsets.only(
                                        //                               right: size
                                        //                                       .width *
                                        //                                   0.05)
                                        //                           : EdgeInsets.only(
                                        //                               left: size
                                        //                                       .width *
                                        //                                   0.05),
                                        //                       child: Text(
                                        //                           '${data2[index]['time']} - ${data2[index]['date']}',
                                        //                           overflow:
                                        //                               TextOverflow
                                        //                                   .fade,
                                        //                           maxLines: 1,
                                        //                           softWrap: true,
                                        //                           style:
                                        //                               const TextStyle(
                                        //                                   fontSize:
                                        //                                       12)),
                                        //                     ),
                                        //                   ),
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //           ),
                                        //         );
                                        //       },
                                        //     ),
                                        //   );
                                        // }
 