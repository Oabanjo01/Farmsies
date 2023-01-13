import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../../Constants/colors.dart';

class Profilepage extends StatefulWidget {
  Profilepage({Key? key}) : super(key: key);

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
      'Title': 'My Addresses',
      'Subtitle': 'Manage your address',
      'Leading Icon': Icons.edit_location_alt_rounded
    },
    {
      'Title': 'Preferences',
      'Subtitle': 'Customize our app',
      'Leading Icon': Icons.settings
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
        .child('Files/DisplayPictures/${_firebaseAuth.currentUser!.uid}')
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
    final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
    final auth.User firebaseUser = _firebaseAuth.currentUser!;
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
                theme == Brightness.light ? textColor2 : primaryDarkColor),
        SliverToBoxAdapter(
          child: SizedBox(height: size.height * 0.05),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          sliver: SliverToBoxAdapter(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(size.width * 0.1),
                child: Image.network(imageUrl,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/Avatars/icons8-circled-user-male-skin-type-6-80.png',
                        ),
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const Center(
                                child: CircularProgressIndicator(),
                              )),
              ),
              title: Text(
                firebaseUser.displayName ?? firebaseUser.email!.toLowerCase(),
              ),
              subtitle: Text(
                firebaseUser.email.toString().toLowerCase(),
              ),
              trailing: Icon(Icons.edit, color: primaryColor),
              tileColor:
                  theme == Brightness.light ? textColor2 : primaryDarkColor,
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
                color:
                    theme == Brightness.light ? textColor2 : primaryDarkColor,
                child: ListTile(
                  leading: Icon(
                    profileItems[index]['Leading Icon'],
                    color: primaryColor,
                  ),
                  title: Text(profileItems[index]['Title']),
                  subtitle: Text(
                    profileItems[index]['Subtitle'],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: primaryColor,
                  ),
                ),
              );
            }, childCount: profileItems.length),
          ),
        )
      ],
    ));
  }
}
