import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authprovider with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future <String> signOut() async {
    try {
      await firebaseAuth.signOut();
      
    } catch (e) {
      e.toString();
    }
  return 'Signed out successfully';
  }
}