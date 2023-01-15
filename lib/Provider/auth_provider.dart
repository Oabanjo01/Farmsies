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

  String _errorMessage = '';

  String get errorMessage {
    return _errorMessage;
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
        case "invalid-email":
          _errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          _errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          _errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          _errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          _errorMessage = "Too many requests. Try again later.";
          break;
        case "operation-not-allowed":
          _errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          _errorMessage = "An undefined Error happened.";
      }
      return _errorMessage;
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
        'userID': user.uid,
        'date': DateTime.now()
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
