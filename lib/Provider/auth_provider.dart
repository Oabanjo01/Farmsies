import 'package:farmsies/Screens/auth-page/login.dart';
import 'package:farmsies/Screens/tabpages/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Models/usermodel.dart';

class Authprovider with ChangeNotifier {
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      // scopes: <String>["email"]
      );
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

  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ); 
    notifyListeners();
    return _userFromFirebase(credential.user);
  }

  Future<UserModel?> createUserWithEmailAndPassword(
    {required String email, required String password, required username}) async {
      try {
        final credential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = credential.user;
        user!.updateDisplayName(username);
        notifyListeners();
        return _userFromFirebase(credential.user);
      } catch (e) {
        rethrow;
      }
    }

  Future<void> signOut() async {
      await firebaseAuth.signOut();
      notifyListeners();
    }

  // handleAuthState() {
  //   return StreamBuilder(
  //       stream: FirebaseAuth.instance.authStateChanges(),
  //       builder: ((context, snapshot) {
  //         if (snapshot.hasData) {
  //           return HomeScreen();
  //         } else {
  //           return LoginScreen();
  //         }
  //       }));
  // }

  // Future<String> signIn() async {
  //   // Start auth flow
  //   final googleUser = await _googleSignIn.signIn(); // The google use we get
  //   // saving the user in our user field
  //   try {
  //     if (googleUser == null) return 'Create an account first';
  //     _user = googleUser;
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final AuthCredential authCredential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
  //     await FirebaseAuth.instance.signInWithCredential(authCredential);
  //     notifyListeners();
  //     return 'Success';
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       return 'No such user';
  //     } else if (e.code == 'invalid-credential') {
  //       return 'Invalide credentials';
  //     } else if (e.code == 'wrong-password') {
  //       return 'Wrong password';
  //     } else {
  //       return e.message.toString();
  //     }
  //   }
  // }
  // Future<String?> signInwithEmailandPassword ({required String email, required String password}) async {
  //   try {
  //     await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  //     notifyListeners();
  //     return 'Sign in succesful';
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'invalid-email') {
  //       return 'This e-mail is invalid';
  //     } else if (e.code == 'wrong-password') {
  //       return 'Incorrect password';
  //     } else {
  //       return e.toString();
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     rethrow;
  //   }
  // }

  // Future<String?> signUp(
  //     {required String email, required String password}) async {
  //   try {
  //     await firebaseAuth.createUserWithEmailAndPassword(
  //         email: email, password: password, );
  //     notifyListeners();
  //     return 'Sign up successful';
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       return 'Weak password, make it has strong as your muscles';
  //     } else if (e.code == 'email-already-in-use') {
  //       return 'This E-mail exists already, Sign in instead?';
  //     } else {
  //       return e.message;
  //     }
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }

  // Future<String> signOut() async {
  //   try {
  //     await firebaseAuth.signOut();
  //     await _googleSignIn.signOut();
  //   } catch (e) {
  //     e.toString();
  //   }
  //   return 'Signed out successfully';
  // }
}
