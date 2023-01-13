import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Models/user-model.dart';

class Authprovider with ChangeNotifier {
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: <String>["email"]
  // );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  // GoogleSignInAccount? _user;
  // GoogleSignInAccount get user => _user!;

  UserModel? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(
      userId: user.uid,
      userMail: user.email,
      userDisplayname: user.displayName,
    );
  }

  Stream<UserModel?>? get user {
    return firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  Future<dynamic> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return _userFromFirebase(credential.user);
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      switch (e.code) {
        case "email-already-in-use":
          return "Email already used. Go to login page.";
        case "wrong-password":
          return "Wrong email/password combination.";
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          return "No user found with this email.";
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          return "User disabled.";
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          return "Too many requests to log into this account.";
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          return "Email address is invalid.";
        default:
          return "Login failed. Please try again.";
      }
    }
  }

  Future<UserModel?> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      String? imagePath,
      required username}) async {
    _isLoading = true;
    CollectionReference _users = _firestore.collection('Users');
    final SettableMetadata metaData =
        SettableMetadata(customMetadata: {'Date': DateTime.now().toString()});
    try {
      _isLoading = true;
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      user!.updateDisplayName(username);
      File file = File(imagePath!);
      await _firebaseStorage
          .ref()
          .child('Files/DisplayPictures/${user.uid}')
          .putFile(file, metaData);
      final Map<String, dynamic> newuser = {
        'email': email,
        'username': username,
        'displayPicture': imagePath,
        'userID': user.uid
      };
      await _users.doc(user.uid).collection('User').doc().set(newuser);
      notifyListeners();
      _isLoading = false;
      return _userFromFirebase(credential.user);
    } catch (e) {
      _isLoading = false;
      rethrow;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    notifyListeners();
  }
}