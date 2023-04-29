import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';

import '../../../Constants/colors.dart';
import '../../../Provider/auth_provider.dart';
import '../../../Widgets/generalwidget/confirmation_dialog.dart';
import '../../../Widgets/generalwidget/error_dialogue.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final List<Map<String, dynamic>> profileItems = [
    {
      'Title': 'My Account',
      'Subtitle': 'Make changes to the account',
      'Leading Icon': Icons.person_rounded
    },
    {
      'Title': 'My Orders',
      'Subtitle': 'Manage your orders',
      'Leading Icon': Icons.shopping_basket_rounded
    },
    {
      'Title': 'Preferences',
      'Subtitle': 'Customize our app',
      'Leading Icon': Icons.settings,
    },
    {
      'Title': 'Log out',
      'Subtitle': 'Log out from your account',
      'Leading Icon': Icons.logout_rounded
    }
  ];
  String imageUrl = '';

  getDownloadUrl() async {
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
    final url = await _firebaseStorage
        .ref()
        .child(
            'Files/DisplayPictures/${_firebaseAuth.currentUser!.email}/${_firebaseAuth.currentUser!.uid}')
        .getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }

  @override
  void initState() {
    getDownloadUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = MediaQuery.of(context).platformBrightness;
    final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    final auth.User firebaseUser = firebaseAuth.currentUser!;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
            title: Text(
              'Account',
              style: TextStyle(
                color:
                    theme == Brightness.dark ? screenColor : primaryDarkColor,
              ),
            ),
            backgroundColor:
                theme == Brightness.light ? textDarkColor : primaryDarkColor),
        SliverToBoxAdapter(
          child: SizedBox(height: size.height * 0.05),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          sliver: SliverToBoxAdapter(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: size.width * 0.05),
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size.width * 0.1),
                  child: SizedBox.expand(
                    child: Image.network(imageUrl,
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              'assets/Avatars/icons8-circled-user-male-skin-type-6-80.png',
                            ),
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  )),
                  ),
                ),
              ),
              title: Text(
                firebaseUser.displayName ?? firebaseUser.email!.toLowerCase(),
              ),
              subtitle: Text(
                firebaseUser.email.toString().toLowerCase(),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: primaryColor),
                onPressed: () => Navigator.pushNamed(context, '/userAccount'),
              ),
              tileColor: theme == Brightness.light
                  ? screenDarkColor.withOpacity(0.1)
                  : screenColor.withOpacity(0.06),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size.width * 0.3)),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: size.height * 0.05),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                color: theme == Brightness.light
                    ? screenDarkColor.withOpacity(0.1)
                    : screenColor.withOpacity(0.06),
                child: ListTile(
                    onTap: () {
                      if (index == 0) {
                        Navigator.pushNamed(context, '/userAccount');
                      } else if (index == 3) {
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
                      } else if (index == 1) {
                        Navigator.pushNamed(context, '/orderHistory');
                      } else if (index == 2) {
                        Navigator.pushNamed(context, '/settings');
                      } else {}
                    },
                    leading: Icon(
                      profileItems[index]['Leading Icon'],
                    ),
                    title: Text(profileItems[index]['Title']),
                    subtitle: Text(
                      profileItems[index]['Subtitle'],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded)),
              );
            }, childCount: profileItems.length),
          ),
        )
      ],
    ));
  }
}
