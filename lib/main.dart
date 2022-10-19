import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Models/dealModel.dart';
import 'package:farmsies/Provider/auth_provider.dart';
import 'package:farmsies/Provider/item_provider..dart';
import 'package:farmsies/routegenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/auth-page/splash_screen.dart';

// Future <SharedPreferences> preferences = SharedPreferences.getInstance();
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
    // final test = provider.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Authprovider()),
        ChangeNotifierProvider.value(value: Itemprovider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        onGenerateRoute: RouteGenerator.generateRoute,
        themeMode: ThemeMode.system,
        theme: ThemeData(
            iconTheme: IconThemeData(
              color: primaryColor,
            ),
            appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                foregroundColor: primaryDarkColor),
            colorScheme: ThemeData().colorScheme.copyWith(
                  primary: primaryColor,
                  secondary: secondaryColor.withOpacity(0.5),
                  brightness: Brightness.light,
                )),
        darkTheme: ThemeData(
            iconTheme: IconThemeData(
              color: primaryColor,
            ),
            appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.light,
                foregroundColor: primaryColor),
            colorScheme: ThemeData().colorScheme.copyWith(
                primary: primaryDarkColor,
                secondary: primaryDarkColor.withOpacity(0.5),
                brightness: Brightness.dark)),
      ),
    );
  }
}
