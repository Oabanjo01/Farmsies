import '../Screens/about_me/about_app.dart';
import '../Screens/about_me/about_developer.dart';
import 'package:farmsies/Screens/all_food_categories.dart';
import 'package:farmsies/Screens/order_complete.dart';
import 'package:farmsies/Screens/settings.dart';
import 'package:farmsies/Screens/product_detail/product_detail.dart';
import 'package:farmsies/Screens/tabpages/order-history.dart';
import 'package:farmsies/Screens/user_account.dart';
import 'package:farmsies/Widgets/onboarding.dart';
import 'package:farmsies/wrapper.dart';
import 'package:flutter/material.dart';

import '../Screens/auth-page/email_verification.dart';
import '../Screens/auth-page/forgot_password.dart';
import '../Screens/auth-page/login.dart';
import '../Screens/auth-page/signupscreen.dart';
import '../Screens/homepage.dart';
import '../Screens/add_product/add_product.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;

    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const onboardingScreen());
      case '/loginScreen':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signupScreen':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/homepage':
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case '/addProduct':
        return MaterialPageRoute(builder: (_) => const AddProduct());
      case '/emailVerification':
        return MaterialPageRoute(builder: (_) => const EmailVerification());
      case '/wrapper':
        return MaterialPageRoute(builder: (_) => const Wrapper());
      case '/foodCategory':
        return MaterialPageRoute(
            builder: (_) => AllFoodCategories(
                  initialTabPage: args,
                ));
      case '/productDetail':
        return MaterialPageRoute(
            builder: (_) => ProductDetail(
                  productDetail: args,
                ));
      case '/orderComplete':
        return MaterialPageRoute(builder: (_) => const OrderComplete());
      case '/orderHistory':
        return MaterialPageRoute(builder: (_) => const OrderHistory());
      case '/userAccount':
        return MaterialPageRoute(builder: (_) => const UserAccount());
      case '/aboutApp':
        return MaterialPageRoute(builder: (_) => const AboutApp());
      case '/aboutDeveloper':
        return MaterialPageRoute(builder: (_) => const AboutDeveloper());
      case '/forgotPassword':
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
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
