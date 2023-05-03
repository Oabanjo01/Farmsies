import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToggleProvider with ChangeNotifier {

  ToggleProvider() {
    initialize();
  }
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode {
    return _themeMode;
  }

  initialize () async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool('ThemeDark') == true) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  setTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (_themeMode == ThemeMode.dark) {

      preferences.setBool('ThemeDark', false);
      _themeMode = ThemeMode.light;
    } else {
      preferences.setBool('ThemeDark', true);
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }
}

  // ThemeData light = ThemeData.light().copyWith(
  //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //       backgroundColor: screenColor, elevation: 0),
  //   scaffoldBackgroundColor: Colors.white,
  //   floatingActionButtonTheme: FloatingActionButtonThemeData(
  //       backgroundColor: primaryColor,
  //       foregroundColor: screenColor,
  //       splashColor: screenColor),
  //   iconTheme: IconThemeData(
  //     color: primaryColor,
  //   ),
  //   appBarTheme: AppBarTheme(
  //       systemOverlayStyle: SystemUiOverlayStyle.dark,
  //       foregroundColor: primaryDarkColor),
  //   colorScheme: ThemeData().colorScheme.copyWith(
  //         primary: primaryColor,
  //         secondary: secondaryColor.withOpacity(0.5),
  //         brightness: Brightness.light,
  //       ),
  // );

  // ThemeData dark = ThemeData.dark().copyWith(
  //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //       backgroundColor: screenDarkColor, elevation: 0),
  //   scaffoldBackgroundColor: screenDarkColor,
  //   floatingActionButtonTheme: FloatingActionButtonThemeData(
  //       backgroundColor: primaryDarkColor,
  //       foregroundColor: primaryColor,
  //       splashColor: primaryColor),
  //   iconTheme: IconThemeData(
  //     color: primaryColor,
  //   ),
  //   appBarTheme: AppBarTheme(
  //       systemOverlayStyle: SystemUiOverlayStyle.light,
  //       foregroundColor: primaryColor),
  //   colorScheme: ThemeData().colorScheme.copyWith(
  //       primary: primaryDarkColor,
  //       secondary: primaryDarkColor.withOpacity(0.5),
  //       brightness: Brightness.dark),
  // );