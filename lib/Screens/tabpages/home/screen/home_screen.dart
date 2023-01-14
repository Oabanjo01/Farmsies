import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Provider/auth_provider.dart';
import 'package:farmsies/Provider/item_provider..dart';
import 'package:farmsies/Widgets/generalwidget/confirmation_dialog.dart';
import 'package:farmsies/Widgets/generalwidget/error_dialogue.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/samples.dart';
import '../../../../Models/item-model.dart';
import '../../../../Utils/other_methods.dart';
import '../widgets/all-deals.dart';
import '../../../../Widgets/generalwidget/text_fields.dart';
import '../widgets/food_categories.dart';
import '../widgets/food_dex.dart';
import '../widgets/head_board.dart';
import '../widgets/homescreen_headers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.userDetails}) : super(key: key);

  final String? userDetails;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();

  final List<ItemModel> _items = [
    ItemModel(
        id: 1,
        description: 'Healthy white cockerels',
        price: 2000,
        title: 'Cockerels',
        category: Category.poultry,
        imagepath:
            'https://images.unsplash.com/photo-1630090374791-c9eb7bab3935?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=872&q=80'),
    ItemModel(
        id: 2,
        description: 'Healthy layers and point of lay.',
        price: 2000,
        title: 'Layers',
        category: Category.poultry,
        imagepath:
            'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cG91bHRyeSUyMGZhcm18ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userDetails = ModalRoute.of(context)!.settings.arguments;
    final firebaseUser = _firebaseAuth.currentUser!;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: CustomScrollView(
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
                                print(userDetails);
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
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                sliver: SliverToBoxAdapter(
                  child: textField(
                    controller: searchController,
                    labelText: 'Search',
                    icon2: IconButton(
                      icon: Icon(
                        Icons.navigate_next_rounded,
                        color: primaryColor,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
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
                              .pushNamed('/foodCategory');
                        }),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                sliver: SliverToBoxAdapter(
                  child: Foodcategories(size: size, food: food),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(bottom: size.height * 0.02, left: 8),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Tips You Should Know',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                sliver: SliverToBoxAdapter(
                  child: Fooddex(size: size, food: food),
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
                        onPressed: () async {
                          // await FirebaseFirestore.instance
                          //     .collection('Products')
                          //     .doc('tV65U7VMYE1Kon4bRYjT')
                          //     .set({
                          //   'id': 'tV65U7VMYE1Kon4bRYjT',
                          //   'title': 'Layers',
                          //   'price': 2000,
                          //   'amount': 15,
                          //   'description': 'Healthy layers and point of lay.',
                          //   'imagepath':
                          //       'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cG91bHRyeSUyMGZhcm18ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60',
                          //   'isFavourited': false,
                          //   'isCarted': false,
                          // });
                        },
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
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                sliver: SliverToBoxAdapter(
                  child: AllDeals(
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
                    child: const Text('Contact us'),
                    onPressed: (() => _launchMail(
                        email: 'banjolakunri@gmail.com',
                        messageBody:
                            'Hello Olabanjo,\n I would like to make enquiries',
                        subject: 'I need more info')),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: spacing(size: size, height: 0.01),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  //

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
        query: 'subject=' +
            Uri.encodeComponent(subject) +
            '&body=' +
            Uri.encodeComponent(messageBody)
        // encodeQueryParameters(<String, String>{subject: messageBody}),
        // queryParameters: {subject: messageBody},
        );
    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri);
      print(email);
    } else {
      print('error');
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
                      final signOut =
                          Provider.of<Authprovider>(context, listen: false)
                              .signOut()
                              .then((value) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/loginScreen',
                          (route) => false,
                        );
                        print(userDetails);
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
                child: Text('Order history'),
                value: 0,
              ),
              const PopupMenuItem(
                child: Text('Setting'),
                value: 1,
              ),
              const PopupMenuItem(
                child: Text('About developer'),
                value: 2,
              ),
              const PopupMenuItem(
                child: Text('App info'),
                value: 3,
              )
            ]);
  }

  onselected(BuildContext context, value) {
    switch (value) {
      case 0:
        print(value);
        break;
      case 1:
        Navigator.pushNamed(context, '/settings');
        break;
      case 2:
        print(value);
        break;
      case 3:
        print(value);
        break;
      default:
    }
  }
}