import 'dart:async';

import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmsies/Models/usermodel.dart';

import '../../Provider/auth_provider.dart';
import '../../wrapper.dart';
import '../tabpages/homescreen.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // bool screenLoaded = false;
  var newLaunch;
  String developername = 'Xerxes';

  String versionNumber = 'V 1.0.0';
  @override
  void initState() {
    super.initState();
    _loadLoginScreen().then((value) {
      if (value == true) {
        Timer(const Duration(seconds: 3),
            (() => Navigator.of(context).popAndPushNamed('/onboarding')));
      } else {
        Future.delayed(
            const Duration(seconds: 3),
            () {
              return Navigator.of(context).popAndPushNamed('/wrapper');
            });}
      });
  }

  Future<bool> _loadLoginScreen() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      bool _newLaunch = _preferences.getBool('newScreen1') ?? true;
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent
      )
    );
    return Scaffold(
        backgroundColor: primaryColor,
        body: Stack(
          children: [
            Center(
              child: Container(
                width: size.width * 0.5,
                child: Image.asset('assets/farmer (1).png'),
              ),
            ),
            Positioned(
                bottom: 10,
                child: Container(
                  width: size.width * 1,
                  child: Column(
                    children: [
                      Text(
                        'Developed by $developername',
                        style: TextStyle(color: textColor),
                      ),
                      Text(
                        versionNumber,
                        style: TextStyle(color: textColor),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }
}
