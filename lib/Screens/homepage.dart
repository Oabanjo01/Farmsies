import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Screens/tabpages/cartscreen.dart';
import 'package:farmsies/Screens/tabpages/homescreen.dart';
import 'package:farmsies/Screens/tabpages/orderscreen.dart';
import 'package:farmsies/Screens/tabpages/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.userDetails}) : super(key: key);

    var userDetails;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int initialBar = 0;

  final List<Map> _tabs = [
    {'label': 'Home', 'icon': Icons.home_outlined,},
    {'label': 'Cart', 'icon': Icons.shopping_cart_outlined,},
    {'label': 'Orders', 'icon': Icons.motorcycle_outlined,},
    {'label': 'Profile', 'icon': Icons.person_outline_rounded,},
  ];

  final List _screens = [
    HomeScreen(),
    Cartspage(),
    Orderspage(),
    Profilepage()
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent
      )
    );
    return SafeArea(
      child: Scaffold(
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
            BottomNavigationBarItem(icon: Icon(_tabs[0]['icon']), label: _tabs[0]['label'], tooltip: _tabs[0]['label'], activeIcon: const Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(_tabs[1]['icon']), label: _tabs[1]['label'], tooltip: _tabs[1]['label'], activeIcon: const Icon(Icons.shopping_cart_rounded)),
            BottomNavigationBarItem(icon: Icon(_tabs[2]['icon']), label: _tabs[2]['label'], tooltip: _tabs[2]['label'], activeIcon: const Icon(Icons.motorcycle_rounded)),
            BottomNavigationBarItem(icon: Icon(_tabs[3]['icon']), label: _tabs[3]['label'], tooltip: _tabs[3]['label'], activeIcon: const Icon(Icons.person)),
          ],
        ),
      ),
    );
  }
}