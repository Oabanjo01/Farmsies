import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor.withOpacity(0.2),
        leading: IconButton(
          icon: Icon(Icons.menu_rounded),
          color: primaryColor,
          onPressed: () {

          }
        ),
        actions: [
          IconButton(
            tooltip: 'Log-out',
            onPressed: () async {
            try {
              await FirebaseAuth.instance.signOut();
              Navigator.popAndPushNamed(context, '/loginScreen');
            } catch (e) {
              
            }
          }, icon: Icon(Icons.logout_rounded, color: primaryColor,)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded, color: primaryColor,)),
        ],
        elevation: 0,
      ),
      backgroundColor: secondaryColor,
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
