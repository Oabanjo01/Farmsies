import 'dart:async';

import 'package:farmsies/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({ Key? key,  }) : super(key: key);
  

  int initialiseScreen = 0;
  

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String developername = 'Xerxes';

  String versionNumber = 'V 1.0.0';

  initScreen () async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    widget.initialiseScreen = await preferences.getInt('onboarding')!;
    await preferences.setInt('key', 1);
  }

  @override
  void initState() {
    super.initState();
    initScreen();
    Timer(const Duration(seconds: 3), () {
      (widget.initialiseScreen == 0 || widget.initialiseScreen == null) ? 
      Navigator.popAndPushNamed(context, '/home') : Navigator.popAndPushNamed(context, '/loginScreen');
    });
  }

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
            child: Column(children: [
              Text('Developed by $developername', style: TextStyle(color: textColor),),
              
              Text(versionNumber, style: TextStyle(color: textColor),)
            ],),
        ))
      ],)
    );
  }
}