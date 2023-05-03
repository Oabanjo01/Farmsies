import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Provider/toggle_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = MediaQuery.of(context).platformBrightness;
    final provider = Provider.of<ToggleProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Settings'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: primaryColor,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                right: size.width * 0.1,
                left: size.width * 0.1,
                top: size.height * 0.03,
                bottom: size.height * 0.01,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Switch Theme',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                        onPressed: () async {
                          provider.setTheme();

                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          final darkMode = preferences.getBool(
                                'ThemeDark',
                              ) ??
                              false;
                          print(darkMode);
                        },
                        icon: provider.themeMode == ThemeMode.dark
                            ? const Icon(
                                Icons.nightlight,
                                color: Colors.grey,
                              )
                            : Icon(
                                Icons.sunny,
                                color: primaryColor,
                              ))
                  ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(
              endIndent: size.width * 0.07,
              indent: size.width * 0.07,
              color: primaryColor,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.01),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Clear Order History',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete,
                        color: errorColor,
                      ),
                      label:
                          Text('Clear', style: TextStyle(color: primaryColor)),
                    )
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
