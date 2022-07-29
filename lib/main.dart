import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Routes/routegenerator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/auth-page/splash_screen.dart';

Future <SharedPreferences> preferences = SharedPreferences.getInstance();
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SharedPreferences _prefs = await preferences;
  // await _prefs.setInt('onboarding', 1);
  runApp(Farmsies());
}

class Farmsies extends StatefulWidget {
  Farmsies({Key? key}) : super(key: key);

  @override
  State<Farmsies> createState() => _FarmsiesState();
}

class _FarmsiesState extends State<Farmsies> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: primaryColor,
          secondary: secondaryColor.withOpacity(0.5),
          brightness: Brightness.light
        )
      ),
      darkTheme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: primaryDarkColor,
          secondary: secondaryColor.withOpacity(0.5),
          brightness: Brightness.dark
        )
      ),
    );
  }
}
