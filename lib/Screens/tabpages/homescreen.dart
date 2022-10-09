import 'package:farmsies/Provider/auth_provider.dart';
import 'package:farmsies/Widgets/generalwidget/confirmationdialog.dart';
import 'package:farmsies/Widgets/generalwidget/errordialogue.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/colors.dart';
import '../../Constants/othermethods.dart';
import '../../Constants/samples.dart';
import '../../Widgets/HomeScreen/PopularDeals.dart';
import '../../Widgets/HomeScreen/headboard.dart';
import '../../Widgets/HomeScreen/homescreenHeaders.dart';
import '../../Widgets/generalwidget/textfields.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, this.userDetails}) : super(key: key);

  final String? userDetails;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    // food.shuffle();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userDetails = ModalRoute.of(context)!.settings.arguments;
    final firebaseUser = _firebaseAuth.currentUser!;
    return SafeArea(
        child: Scaffold(
      appBar: appBar(context, userDetails),
      extendBodyBehindAppBar: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: ListView(shrinkWrap: true, children: <Widget>[
          Headboard(
              size: size,
              username: firebaseUser.displayName ??
                  firebaseUser.email!.toLowerCase()),
          spacing(size: size, height: 0.02),
          Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: textField(
                controller: searchController,
                labelText: 'Search',
                icon: const Icon(Icons.search),
                color: Colors.transparent,
                baseColor: Colors.grey.shade200,
              )),
          spacing(size: size, height: 0.02),
          HomescreenHeader(
              text1: 'Categories',
              text2: 'See All',
              navigate: () => () {
                    return Navigator.of(context).pushNamed('/foodCategory');
                  }),
          Foodcategories(size: size, food: food),
          Container(
              margin: EdgeInsets.only(bottom: size.height * 0.02, left: 8),
              alignment: Alignment.centerLeft,
              child: const Text('Tips You Should Know',
                  style: const TextStyle(fontSize: 20))),
          Fooddex(size: size, food: food),
          spacing(size: size, height: 0.01),
          Container(
              margin: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('All Deals', style: TextStyle(fontSize: 20)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.filter_list_alt,
                        color: primaryColor,
                      ))
                ],
              )),
          spacing(size: size, height: 0.01),
          PopularDeals(size: size, food: food),
          spacing(size: size, height: 0.01),
          SizedBox(
              child: TextButton(
            child: const Text('Contact us'),
            onPressed: (() => _launchMail(
                email: 'banjolakunri@gmail.com',
                messageBody: 'Hello Olabanjo,\n I would like to make enquiries',
                subject: 'I need more info')),
          )),
          spacing(size: size, height: 0.01)
        ]),
      ),
    ));
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

  AppBar appBar(BuildContext context, Object? userDetails) {
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

class Fooddex extends StatelessWidget {
  const Fooddex({
    Key? key,
    required this.size,
    required this.food,
  }) : super(key: key);

  final Size size;
  final List food;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(width: size.width * 0.05,),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: food.length,
          itemBuilder: ((context, index) {
            return Stack(children: [
              Container(
                width: size.width * 0.8,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ClipRRect(
                  child: Image.network(
                    food[index].imagepath,
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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.02,
                right: size.height * 0.03,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        width: size.width * 0.55,
                        child: Text(
                          food[index].title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              fontSize: 18,
                              fontStyle: FontStyle.italic),
                        )),
                    Container(
                      alignment: Alignment.centerRight,
                      width: size.width * 0.6,
                      child: Text(
                        food[index].description,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ]);
          })),
      height: size.height * 0.25,
    );
  }
}

class Foodcategories extends StatelessWidget {
  const Foodcategories({
    Key? key,
    required this.size,
    required this.food,
  }) : super(key: key);

  final Size size;
  final List<TipsDeck> food;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.12,
      // padding: const EdgeInsets.only(right: 10),
      child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) =>
              SizedBox(width: size.width * 0.03),
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext ctx, index) {
            return InkWell(
              onTap: () {
                print(foodcategories.length);
              },
              child: Column(
                children: [
                  SizedBox(
                    // margin: EdgeInsets.only(left: size.width * 0.04),
                    // height: size.width * 0.1,
                    width: size.width * 0.15,
                    height: size.height * 0.07,
                    child: Center(
                      child: Image.asset(foodcategories[index]['food icon']),
                    ),
                  ),
                  spacing(size: size, height: 0.01),
                  Text(
                    foodcategories[index]['food name'],
                    style: const TextStyle(overflow: TextOverflow.fade),
                  )
                ],
              ),
            );
          }),
    );
  }
}
