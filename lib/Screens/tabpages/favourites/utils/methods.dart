import 'package:shared_preferences/shared_preferences.dart';

class Methods {
  final valueofSharedPrferences = 'togglers';

  Future <bool> saveTogglemode (value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool(valueofSharedPrferences, value);
  }

  Future <bool> getCurrentTogglemode () async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    // print(preferences.getBool(valueofSharedPrferences));
    final bool toggleMode = preferences.getBool(valueofSharedPrferences) ?? false;
    return toggleMode;
  }
} 