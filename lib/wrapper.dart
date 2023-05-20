import 'dart:async';

// import 'package:farmsies/Provider/auth_provider.dart';
// import 'package:farmsies/Models/user-model.dart';
// import 'package:farmsies/Screens/auth-page/email_verification.dart';
// import 'package:farmsies/Screens/auth-page/login.dart';
// import 'package:farmsies/Screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
        _authSubscription = FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        if (user.emailVerified) {
          Navigator.pushReplacementNamed(context, '/homepage',);
        } else{
          Navigator.pushReplacementNamed(context, '/emailVerification');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/loginScreen');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // // final authProvider = Provider.of<Authprovider>(context);
    // final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
    // final User currentUser = firebaseAuth.currentUser!;
    return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // return StreamBuilder<User?>(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (BuildContext ctx, AsyncSnapshot<User?> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.active) {
    //         if (snapshot.hasData) {
    //           if (snapshot.data!.emailVerified) {
    //             return HomePage();
    //           } return const EmailVerification();
    //         } else {
    //           return const LoginScreen();
    //         }
    //         // final User? user = snapshot.data;
    //         //   if (user != null) {
    //         //     return HomePage();
    //         //   } else {
    //         //     return const LoginScreen();
    //         //   }
    //       } else {
    //         return const Scaffold(
    //             body: Center(child: CircularProgressIndicator()));
    //       }
    //     });
  }
}
