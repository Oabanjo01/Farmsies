import 'package:farmsies/Provider/auth_provider.dart';
import 'package:farmsies/Models/usermodel.dart';
import 'package:farmsies/Screens/auth-page/login.dart';
import 'package:farmsies/Screens/tabpages/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context);
    return StreamBuilder<Users?>(
      stream: authProvider.user,
      builder: (BuildContext ctx, AsyncSnapshot<Users?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final Users? user = snapshot.data;
          return user == null ? LoginScreen() : HomeScreen();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      });
  }
}