// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Models/user-model.dart';
import '../Utils/snack_bar.dart';

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
    if (user != null && user.emailVerified) {
      return UserModel(
        userId: user.uid,
        userMail: user.email,
        userDisplayname: user.displayName,
      );
    }
    return null;
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

  Future<User?> signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
      _isLoading = true;
    try {
      final credential = await firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );
          // .then((credential) {
        notifyListeners();
      _isLoading = false;
        return credential.user;
      // });
    } on SocketException catch (e) {
      _isLoading = false;
      _errorMessage = e.message.toString();
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      debugPrint('Error happened - ${e.code}');
      debugPrint(isLoading.toString());
      switch (e.code) {
        case "invalid-email":
          _errorMessage = "Your email address appears to be malformed.";
          break;
          case "too-many-requests":
          _errorMessage = "Login failed, please try again😊";
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
          _errorMessage =
              "An undefined Error happened, might be your internet.";
      }
    }
  }

  Future<UserModel?> createUserWithEmailAndPassword(
      {required String email,
      required BuildContext context,
      required String password,
      String? imagePath,
      required username}) async {
    _isLoading = true;
    CollectionReference users = _firestore.collection('Users');
    final SettableMetadata metaData =
        SettableMetadata(customMetadata: {'Date': DateTime.now().toString()});
    try {
      _isLoading = true;
      await firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((credential) async {
        final SnackBar showSnackBar = snackBar(
            context, 'Check your mail for verification mail please', 5);
        ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
        User? user = credential.user;
        user!.sendEmailVerification().then((value) async {
          user.updateDisplayName(username);
          File file = File(imagePath!);
          await _firebaseStorage
              .ref()
              .child('Files/DisplayPictures/$email/${user.uid}')
              .putFile(file, metaData);
          final Map<String, dynamic> newuser = {
            'email': email,
            'username': username,
            'displayPicture': imagePath,
            'userID': user.uid,
            'date': DateTime.now().toIso8601String().split('T').first
          };
          await users.doc(user.uid).collection('User').doc(email).set(newuser);
          return _userFromFirebase(credential.user);
        });
      });
      notifyListeners();
      _isLoading = false;
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
