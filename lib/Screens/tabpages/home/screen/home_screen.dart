import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Provider/auth_provider.dart';
import 'package:farmsies/Widgets/generalwidget/confirmation_dialog.dart';
import 'package:farmsies/Widgets/generalwidget/error_dialogue.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/samples.dart';
import '../../../../Utils/other_methods.dart';
import '../../../../Utils/snack_bar.dart';
import '../widgets/all_deals.dart';
import '../../../../Widgets/generalwidget/text_fields.dart';
import '../widgets/food_categories.dart';
import '../widgets/tips_deck.dart';
import '../widgets/head_board.dart';
import '../widgets/homescreen_headers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  List<DocumentSnapshot> allProducts = [];
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('Products');

  Stream<QuerySnapshot> get products {
    return collection.snapshots();
  }

  void listentoProductChanges() async {
    final snapshots = await collection.get();
    if (snapshots.docs.isEmpty) {}
    collection.get().then((value) {
      setState(() {});
      allProducts = value.docs;
    });
  }

  @override
  void didChangeDependencies() {
    listentoProductChanges();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final firebaseUser = _firebaseAuth.currentUser!;
    final theme = Theme.of(context).brightness;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              listentoProductChanges();
              final SnackBar showSnackBar = snackBar(context, 'Refreshed', 1,
                  size.width * 0.3, primaryColor.withOpacity(0.1));
              ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
            },
            color: primaryColor.withOpacity(0.1),
            backgroundColor:
                theme == Brightness.dark ? screenDarkColor : screenColor,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      tooltip: 'Log-out',
                      onPressed: () async {
                        confirm(
                            context: context,
                            title: 'Confirm Log out',
                            content: 'Are you sure you want to log out?',
                            onClicked1: () async {
                              try {
                                await Provider.of<Authprovider>(context,
                                        listen: false)
                                    .signOut()
                                    .then((value) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/loginScreen',
                                    (route) => false,
                                  );
                                });
                              } catch (e) {
                                errorDialogue(context, e.toString());
                              }
                            },
                            onClicked2: () {
                              Navigator.pop(context);
                            },
                            textbutton1: 'Yes',
                            textbutton2: 'No');
                      },
                      icon: Icon(
                        Icons.logout_rounded,
                        color: primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: popupdialog(context),
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: Headboard(size: size, username: firebaseUser),
                ),
                SliverToBoxAdapter(
                  child: spacing(
                    size: size,
                    height: 0.02,
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  sliver: SliverToBoxAdapter(
                    child: textField(
                      labelText: 'Search',
                      icon: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                      color: Colors.transparent,
                      baseColor: Colors.grey.shade200,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: spacing(size: size, height: 0.02),
                ),
                SliverToBoxAdapter(
                  child: HomescreenHeader(
                      text1: 'Categories',
                      text2: 'See All',
                      navigate: () => () {
                            return Navigator.of(context)
                                .pushNamed('/foodCategory', arguments: 0);
                          }),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  sliver: SliverToBoxAdapter(
                    child: Foodcategories(size: size,),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin:
                        EdgeInsets.only(bottom: size.height * 0.02, left: 8),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Tips You Should Know',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  sliver: SliverToBoxAdapter(
                    child: Fooddex(size: size),
                  ),
                ),
                SliverToBoxAdapter(
                  child: spacing(size: size, height: 0.01),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('All Deals', style: TextStyle(fontSize: 20)),
                        IconButton(
                          onPressed: () async {},
                          icon: Icon(
                            Icons.filter_list_alt,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: spacing(size: size, height: 0.01),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  sliver: SliverToBoxAdapter(
                    child: AllDeals(
                      allProducts: allProducts,
                      size: size,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: spacing(size: size, height: 0.01),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    child: TextButton(
                      onPressed: (() => _launchMail(
                          email: 'banjolakunri@gmail.com',
                          messageBody:
                              'Hello Olabanjo,\n I would like to make enquiries',
                          subject: 'I need more info')),
                      child: const Text('Contact us'),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: spacing(size: size, height: 0.01),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            tooltip: 'Add your product',
            onPressed: () {
              Navigator.of(context).pushNamed('/addProduct');
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> parameters) {
    return parameters.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future _launchMail(
      {required String email,
      required String subject,
      required String messageBody}) async {
    final url =
        'mailto: $email?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(messageBody)}';
    final Uri mailtoUri = Uri(
        scheme: 'mailto',
        path: email,
        query:
            'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(messageBody)}'
        // encodeQueryParameters(<String, String>{subject: messageBody}),
        // queryParameters: {subject: messageBody},
        );
    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri);
    } else {
      return;
    }
  }

  AppBar appBar(BuildContext context, Object? userDetails, String id) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
            tooltip: 'Log-out',
            onPressed: () async {
              confirm(
                  context: context,
                  title: 'Confirm Log out',
                  content: 'Are you sure you want to log out?',
                  onClicked1: () {
                    try {
                      Provider.of<Authprovider>(context, listen: false)
                          .signOut()
                          .then((value) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/loginScreen',
                          (route) => false,
                        );
                      });
                    } catch (e) {
                      errorDialogue(context, e.toString());
                    }
                  },
                  onClicked2: () {
                    Navigator.pop(context);
                  },
                  textbutton1: 'Yes',
                  textbutton2: 'No');
            },
            icon: Icon(
              Icons.logout_rounded,
              color: primaryColor,
            )),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: popupdialog(context),
        )
      ],
      elevation: 0,
    );
  }

  PopupMenuButton<int> popupdialog(BuildContext context) {
    return PopupMenuButton<int>(
        onSelected: (value) => onselected(context, value),
        elevation: 1,
        position: PopupMenuPosition.under,
        icon: Icon(Icons.more_vert_rounded, color: primaryColor),
        itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Order history'),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text('Setting'),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text('About developer'),
              ),
              const PopupMenuItem(
                value: 3,
                child: Text('App info'),
              )
            ]);
  }

  onselected(BuildContext context, value) {
    switch (value) {
      case 0:
        Navigator.pushNamed(context, '/orderHistory');
        break;
      case 1:
        Navigator.pushNamed(context, '/settings');
        break;
      case 2:
        Navigator.pushNamed(context, '/aboutApp');
        break;
      case 3:
        Navigator.pushNamed(context, '/aboutDeveloper');
        break;
      default:
    }
  }
}
