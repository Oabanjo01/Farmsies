import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Orderspage extends StatelessWidget {
  const Orderspage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent));
    return Scaffold(
      body: Center(
        child: Text('Order'),
      ),
    );
  }
}
