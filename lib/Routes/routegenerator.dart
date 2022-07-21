import 'package:farmsies/Screens/home.dart';

import 'package:farmsies/Screens/login.dart';
import 'package:farmsies/Screens/signupscreen.dart';
import 'package:farmsies/Widgets/onboarding.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => onboardingScreen(
        ));
      case '/loginScreen':
          return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/signupScreen':
          return MaterialPageRoute(builder: (_) => SignupScreen());
      default: 
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Error!',
            style: TextStyle(color: Colors.red, fontSize: 30),
          ),
        ),
      );
    });
  }
}