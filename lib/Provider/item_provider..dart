// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Models/item-model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import 'dart:core';

import '../Utils/snack_bar.dart';

class Itemprovider with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;

  bool _isToggled = false;

  bool get isToggled {
    return _isToggled;
  }

  Future<void> addProduct(ItemModel item1) async {
    final Map<String, dynamic> item = item1.toMap();
    CollectionReference collectionReference = db.collection('Products');
    try {
      await collectionReference.add(item);
    } catch (e) {
      return;
    }
  }

  Future<void> toggler(QueryDocumentSnapshot data, String uid,
      String collection, int amount, BuildContext context, String carted, String unCarted) async {
    String id = data.id;
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection(collection)
        .doc(id);
    final doc = await documentReference.get();
    if (doc.exists || doc.data() != null) {
      await documentReference.delete().then((value) {
        final SnackBar showSnackBar = snackBar(unCarted, 1);
        _isToggled = false;
        ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
      });
      notifyListeners();
    } else if (!doc.exists) {
      await documentReference.set({
        'id': id,
        'title': data['title'],
        'price': data['price'],
        'amount': amount,
        'description': data['description'],
        'imagepath': data['imagepath'],
        'isFavourited': true,
        'isCarted': true,
      }).then((value) {
        final SnackBar showSnackBar = snackBar(carted, 1);
_isToggled = true;
        ScaffoldMessenger.of(context).showSnackBar(showSnackBar);
      });
      notifyListeners();
    }
  }
}
