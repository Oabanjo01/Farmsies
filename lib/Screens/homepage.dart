// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:farmsies/Screens/tabpages/favourites/screens/favourites_screen.dart';
import 'package:farmsies/Screens/tabpages/home/screen/home_screen.dart';
import 'package:farmsies/Screens/tabpages/order/screens/order_screen.dart';
import 'package:farmsies/Screens/tabpages/profile/profilescreen.dart';
import 'package:flutter/material.dart';

import '../Constants/colors.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key,}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int initialBar = 0;

  final List<Map> _tabs = [
    {'label': 'Home', 'icon': Icons.home_outlined,},
    {'label': 'Favourites', 'icon': Icons.favorite_outline_rounded,},
    {'label': 'Cart', 'icon': Icons.shopping_cart_outlined,},
    {'label': 'Profile', 'icon': Icons.person_outline_rounded,},
  ];

  final List _screens = [
    const HomeScreen(),
    const FavouritesPage(),
    const Orderspage(),
    const Profilepage()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          _screens[initialBar]
        ],),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedFontSize: 16,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          currentIndex: initialBar,
          onTap: (index) => setState(() => initialBar = index), 
          unselectedItemColor: primaryColor.withOpacity(0.7),
          selectedItemColor: primaryColor,
          items: [
            BottomNavigationBarItem(icon: Icon(_tabs[0]['icon']), label: _tabs[0]['label'], tooltip: _tabs[0]['label'], activeIcon: const Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(_tabs[1]['icon']), label: _tabs[1]['label'], tooltip: _tabs[1]['label'], activeIcon: const Icon(Icons.favorite_rounded)),
            BottomNavigationBarItem(icon: Icon(_tabs[2]['icon']), label: _tabs[2]['label'], tooltip: _tabs[2]['label'], activeIcon: const Icon(Icons.shopping_cart_rounded)),
            BottomNavigationBarItem(icon: Icon(_tabs[3]['icon']), label: _tabs[3]['label'], tooltip: _tabs[3]['label'], activeIcon: const Icon(Icons.person_rounded)),
          ],
        ),
      ),
    );
  }
}