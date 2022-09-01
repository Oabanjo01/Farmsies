import 'package:farmsies/Screens/settings.dart';
import 'package:farmsies/Widgets/onboarding.dart';
import 'package:flutter/material.dart';

import 'Screens/auth-page/login.dart';
import 'Screens/auth-page/signupscreen.dart';
import 'Widgets/homepage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const onboardingScreen(
        ));
      case '/loginScreen':
          return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/signupScreen':
          return MaterialPageRoute(builder: (_) => SignupScreen());
      case '/homepage':
          return MaterialPageRoute(builder: (_) => HomePage());
      case '/settings':
          return MaterialPageRoute(builder: (_) => SettingsPage());
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