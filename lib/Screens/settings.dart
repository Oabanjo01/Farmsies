import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Settings')),
    );
  }
}

// body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: ((context, snapshot) {
//           if(snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator(),);
//           } else if (snapshot.hasError) {
//             return erroDialogue(context);
//           } else if (snapshot.hasData) {
//             return HomeScreen();
//           } else {