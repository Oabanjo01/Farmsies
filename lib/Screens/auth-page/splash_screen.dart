// ignore_for_file: prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var newLaunch;
  String developername = 'Xerxes';

  String versionNumber = 'V 1.0.0';
  @override
  void initState() {
    super.initState();
    _loadLoginScreen().then((value) async {
      if (value == true) {
        Timer(const Duration(seconds: 3),
            (() => Navigator.of(context).popAndPushNamed('/onboarding')));
      } else {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        DateTime _lastoginTime =
            DateTime.tryParse(preferences.get('lastLoginTime').toString()) ??
                DateTime.now();
        final difference = DateTime.now().difference(_lastoginTime).inMinutes;
        if (difference > 5) {
          if (mounted) {
            final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
            if (firebaseAuth.currentUser != null) {
              await firebaseAuth.signOut().then((value) {
                Navigator.popAndPushNamed(context, '/loginScreen');
                preferences.setString(
                    'lastLoginTime', DateTime.now().toString());
              });
            } else {
              if (mounted) {
                Navigator.popAndPushNamed(context, '/loginScreen');
                preferences.setString(
                    'lastLoginTime', DateTime.now().toString());
              }
            }
          }
        } else {
          Future.delayed(const Duration(seconds: 3), () {
            return Navigator.of(context)
                .popAndPushNamed('/wrapper')
                .then((value) {
              preferences.setString('lastLoginTime', DateTime.now().toString());
            });
          });
        }
      }
    });
  }

  Future<bool> _loadLoginScreen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      bool _newLaunch = preferences.getBool('newScreen1') ?? true;
      newLaunch = _newLaunch;
    });
    return newLaunch;
  }

  checkSplashScreenran() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('newScreen1')) {
      prefs.setBool('newScreen1', false);
    } else {
      prefs.setBool('newScreen1', false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    checkSplashScreenran();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).brightness;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent));
    return Scaffold(
        backgroundColor:
            theme == Brightness.dark ? primaryDarkColor : primaryColor,
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                width: size.width * 0.5,
                child: Image.asset('assets/farmer (1).png'),
              ),
            ),
            Positioned(
                bottom: 10,
                child: SizedBox(
                  width: size.width * 1,
                  child: Column(
                    children: [
                      Text(
                        'Developed by $developername',
                        style: TextStyle(
                            color: theme == Brightness.light
                                ? textColor
                                : textDarkColor),
                      ),
                      Text(
                        versionNumber,
                        style: TextStyle(
                            color: theme == Brightness.light
                                ? textColor
                                : textDarkColor),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }
}
