// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import 'dart:core';

import '../Utils/snack_bar.dart';

class Itemprovider with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;

  final Map<String, bool> _isToggled = {};

  Future<bool> isToggledStatus(
    DocumentSnapshot data,
    String productId,
    String uid,
    String collection,
  ) async {
    String id = data.id;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection(collection)
        .doc(id)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        _isToggled[productId] = true;
        notifyListeners();
        return _isToggled[productId];
      } else {
        _isToggled[productId] = false;
        notifyListeners();
        return _isToggled[productId];
      }
    });
    return  _isToggled[productId] ?? false;
  }

  Future<void> toggler(DocumentSnapshot data, String uid, String collection,
      int amount, BuildContext context, String carted, String unCarted) async {
    String id = data.id;
    String docId = '';
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection(collection)
        .doc(id);
    try {
      await documentReference.get().then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          docId = snapshot['id'];
        } else {
          docId = '';
        }
      });
      if (docId == '') {
        _isToggled[id] = true;
        await documentReference.set({
          'id': id,
          'itemCreator': data['itemCreator'],
          'title': data['title'],
          'price': data['price'],
          'amount': amount,
          'description': data['description'],
          'imagepath': data['imagepath'],
          'date': DateTime.now().toIso8601String().split('T').first,
          'email': firebaseAuth.currentUser!.email,
          'isFavourited': true,
          'isCarted': true,
        }).then((value) {
          final SnackBar showSnackBar = snackBar(context, carted, 1);
          ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
        });
        notifyListeners();
      } else if (docId == id) {
        _isToggled[id] = false;
        await documentReference.delete().then((value) {
          final SnackBar showSnackBar = snackBar(context, unCarted, 1);
          ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
        });
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {}
  }
}