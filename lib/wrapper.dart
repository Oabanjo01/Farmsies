import 'package:farmsies/Provider/auth_provider.dart';
import 'package:farmsies/Models/user-model.dart';
import 'package:farmsies/Screens/auth-page/login.dart';
import 'package:farmsies/Screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context);
    return StreamBuilder<UserModel?>(
      stream: authProvider.user,
      builder: (BuildContext ctx, AsyncSnapshot<UserModel?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final UserModel? user = snapshot.data;
          return user == null ? const LoginScreen() : HomePage();
        }else {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      });
  }
}