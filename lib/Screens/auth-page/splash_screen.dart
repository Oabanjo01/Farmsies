import 'dart:async';

import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String developername = 'Xerxes';

  String versionNumber = 'V 1.0.0';

  final Future<SharedPreferences> _preferences =
      SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _loadanotherScreen();
    // final _initialiseScreen = _preferences.then((SharedPreferences prefs) {
    //   return (prefs.getBool('onboarding') ?? false);
    // });
    // print(_initialiseScreen);
  }

  _loadanotherScreen () {
    Timer(const Duration(seconds: 3), checkFirstSeen);
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _introSeen = (prefs.getBool('showonOnboarding') ?? false);

    if (_introSeen) {
      Navigator.popAndPushNamed(context, '/home');
    } else {
      await prefs.setBool('showonOnboarding', true);
      Navigator.popAndPushNamed(context, '/loginScreen');
    }}

  // Future initScreen() async {
  //   SharedPreferences prefs = await _preferences;
  //   bool _initialiseScreen = prefs.getBool('onboarding') ?? false;

  // //     if (_initialiseScreen) {
  // //       Navigator.popAndPushNamed(context, '/home');
  // //   } else {
  // //     await prefs.setBool('onboarding', true);
  // //     Navigator.popAndPushNamed(context, '/loginScreen');
  // // }

  //   // final int _initialiseScreen = prefs.getInt('onboarding') ?? 0;
  // }
 

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
  }}


