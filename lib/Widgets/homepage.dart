import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Screens/tabpages/cartscreen.dart';
import 'package:farmsies/Screens/tabpages/homescreen.dart';
import 'package:farmsies/Screens/tabpages/orderscreen.dart';
import 'package:farmsies/Screens/tabpages/profilescreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int initialBar = 0;

  final List<Map> _tabs = [
    {'label': 'Home', 'icon': Icons.home_filled,},
    {'label': 'Cart', 'icon': Icons.shopping_bag_rounded,},
    {'label': 'Orders', 'icon': Icons.directions_bike_rounded,},
    {'label': 'Profile', 'icon': Icons.person,},
  ];

  List _screens = [
    HomeScreen(),
    Cartspage(),
    Orderspage(),
    Profilepage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: secondaryColor,
      //   leading: Icon(Icons.menu, color: primaryColor,),
      //   title: Text('Home', style: TextStyle(color: primaryColor),),
      // ),
      body: _screens[initialBar],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white24,
        showUnselectedLabels: true,
        selectedFontSize: 16,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.shifting,
        elevation: 1,
        currentIndex: initialBar,
        onTap: (index) => setState(() => initialBar = index), 
        unselectedItemColor: primaryColor.withOpacity(0.7),
        selectedItemColor: primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(_tabs[0]['icon']), label: _tabs[0]['label']),
          BottomNavigationBarItem(icon: Icon(_tabs[1]['icon']), label: _tabs[1]['label']),
          BottomNavigationBarItem(icon: Icon(_tabs[2]['icon']), label: _tabs[2]['label']),
          BottomNavigationBarItem(icon: Icon(_tabs[3]['icon']), label: _tabs[3]['label']),
        ],
      ),
    );
  }
}