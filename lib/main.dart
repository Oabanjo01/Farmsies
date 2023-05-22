import 'package:farmsies/Provider/auth_provider.dart';
import 'package:farmsies/Provider/file_provider.dart';
import 'package:farmsies/Provider/item_provider..dart';
import 'package:farmsies/Utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants/colors.dart';
import 'Provider/toggle_theme.dart';
import 'Screens/auth-page/splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final darkMode = preferences.getBool(
        'ThemeDark',
      ) ??
      false;
  runApp(Farmsies(
    themeMode: darkMode,
  ));
}

class Farmsies extends StatefulWidget {
  const Farmsies({Key? key, required this.themeMode}) : super(key: key);

  final bool themeMode;

  @override
  State<Farmsies> createState() => _FarmsiesState();
}

class _FarmsiesState extends State<Farmsies> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Authprovider()),
          ChangeNotifierProvider.value(value: Itemprovider()),
          ChangeNotifierProvider.value(value: FileProvider()),
          ChangeNotifierProvider.value(value: ToggleProvider()..initialize()),
        ],
        builder: (context, child) {
          final theme = Provider.of<ToggleProvider>(context);
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: MaterialApp(
              scaffoldMessengerKey: scaffoldMessengerKey,
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
              onGenerateRoute: RouteGenerator.generateRoute,
              themeMode: theme.themeMode,
              theme: ThemeData(
                  useMaterial3: true,
                  primaryColor: primaryColor,
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      backgroundColor: screenColor, elevation: 0),
                  scaffoldBackgroundColor: screenColor,
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    
                    shape: const CircleBorder(),
                      backgroundColor: primaryColor.withOpacity(0.8),
                      foregroundColor: screenColor,
                      splashColor: screenColor),
                  iconTheme: IconThemeData(
                    color: primaryColor,
                  ),
                  brightness: Brightness.light,
                  
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ButtonStyle(
                      shape: 
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      backgroundColor: MaterialStateProperty.all(
                              primaryColor.withOpacity(0.7)
                            ),
                      foregroundColor: MaterialStateProperty.all(
                              textColor,
                            ),
                    )
                  ),
                  appBarTheme: AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle.dark,
                      foregroundColor: primaryDarkColor),
                  // colorScheme: ThemeData().colorScheme.copyWith(
                  //       primary: primaryColor,
                  //       secondary: secondaryColor.withOpacity(0.5),
                  //       brightness: Brightness.light,
                  //     )),
                  colorScheme: ColorScheme.fromSwatch(
                    brightness: Brightness.light,
                    backgroundColor: screenColor,
                    errorColor: errorColor,
                    primarySwatch: Colors.green
                  ),),
              darkTheme: ThemeData(
                  useMaterial3: true,
                  progressIndicatorTheme: ProgressIndicatorThemeData(
                    color: primaryColor
                  ),
                  brightness: Brightness.dark,
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      backgroundColor: screenDarkColor, elevation: 0),
                  scaffoldBackgroundColor: screenDarkColor,
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    shape: CircleBorder(side: BorderSide(color: primaryColor.withOpacity(0.4), width: 0.0)),
                      backgroundColor: primaryDarkColor,
                      foregroundColor: primaryColor,
                      splashColor: primaryColor),
                  iconTheme: IconThemeData(
                    color: primaryColor,
                  ),
                  backgroundColor: primaryDarkColor,
                  appBarTheme: AppBarTheme(
                    elevation: 0,
                    systemOverlayStyle: SystemUiOverlayStyle.light,
                    foregroundColor: primaryColor,
                    backgroundColor: screenDarkColor,
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ButtonStyle(
                      shape: 
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      backgroundColor: MaterialStateProperty.all(
                              primaryColor.withOpacity(0.5)
                            ),
                      foregroundColor: MaterialStateProperty.all(
                              textDarkColor,
                            ),
                    )
                  ),
                  colorScheme: ColorScheme.fromSwatch(
                    brightness: Brightness.dark,
                    backgroundColor: primaryDarkColor,
                    errorColor: errorColor,
                    primarySwatch: Colors.green
                  )),
            ),
          );
        });
  }
}