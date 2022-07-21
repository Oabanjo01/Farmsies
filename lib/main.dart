import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Routes/routegenerator.dart';
import 'package:farmsies/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.setInt('onboarding', 1);
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
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: primaryColor,
          secondary: secondaryColor.withOpacity(0.5)
        )
      ),
    );
  }
}
