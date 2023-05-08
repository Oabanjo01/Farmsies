import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Provider/toggle_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).brightness;
    final provider = Provider.of<ToggleProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Settings'),
            elevation: 0,
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: primaryColor,
                )),
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
                        },
                        icon: provider.themeMode == ThemeMode.dark
                            ? Icon(
                                Icons.sunny,
                                color: primaryColor,
                              )
                            : const Icon(
                                Icons.nightlight_round,
                                color: Colors.grey,
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
