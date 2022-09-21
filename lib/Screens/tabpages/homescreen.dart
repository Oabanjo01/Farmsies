import 'package:farmsies/Models/item-model.dart';
import 'package:farmsies/Provider/auth_provider.dart';
import 'package:farmsies/Widgets/generalwidget/confirmationdialog.dart';
import 'package:farmsies/Widgets/generalwidget/errordialogue.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void initState() {
    food.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userDetails = ModalRoute.of(context)!.settings.arguments;
    final firebaseUser = _firebaseAuth.currentUser!;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent));
    return Scaffold(
        appBar: appBar(context, userDetails),
        extendBodyBehindAppBar: false,
        backgroundColor: secondaryColor,
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(children: [
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
              HomescreenHeader(text1: 'Categories', text2: 'See All', navigate: () => () {
                return Navigator.of(context).pushNamed('/foodCategory');
              }),
              Foodcategories(size: size, food: food),
              HomescreenHeader(
                  text1: 'Special Deals for You', text2: 'See All', navigate: () => null),
              Fooddex(size: size, food: food),
              spacing(size: size, height: 0.02),
              HomescreenHeader(text1: 'Popular Deals', text2: 'See All', navigate: () => null),
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
      query: 'subject=' + Uri.encodeComponent(subject) + '&body=' + Uri.encodeComponent(messageBody)
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
                        Navigator.popAndPushNamed(context, '/loginScreen');
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
  final List<ItemModel> food;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
          clipBehavior: Clip.antiAlias,
          scrollDirection: Axis.horizontal,
          itemCount: food.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: size.width * 0.02,
            mainAxisExtent: size.width * 0.8,
          ),
          itemBuilder: ((context, index) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ClipRRect(
                child: Image.network(
                  food[index].imagepath,
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            );
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
  final List<ItemModel> food;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.1,
      child: ListView.separated(
          separatorBuilder: (context, index) =>
              SizedBox(width: size.width * 0.03),
          itemCount: foodcategories.length = 5,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext ctx, index) {
            return InkWell(
              onTap: () {},
              child: Column(
                children: [
                  SizedBox(
                    // margin: EdgeInsets.only(left: size.width * 0.04),
                    // height: size.width * 0.1,
                    width: size.width * 0.15,
                    child: Center(
                      child: Image.asset(foodcategories[index]['food icon']),
                    ),
                  ),
                  spacing(size: size, height: 0.01),
                  Text(foodcategories[index]['food name'], style: const TextStyle(overflow: TextOverflow.fade),)
                ],
              ),
            );
          }),
    );
  }
}
