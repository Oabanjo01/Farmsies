import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Models/item-model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import 'dart:core';

class Itemprovider with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;

  final List<ItemModel> _itemsFavourited = [];
  final List<ItemModel> _itemsCarted = [];

  List<ItemModel> get itemsfavourited {
    return _itemsFavourited;
  }

  List<ItemModel> get itemsCarted {
    return _itemsCarted;
  }

  Future<void> removeItem(ItemModel itemIndex) async {
    _itemsFavourited.remove(itemIndex);
    notifyListeners();
  }

  Future<void> addProduct(ItemModel item1) async {
    final Map<String, dynamic> item = item1.toMap();
    CollectionReference collectionReference = db.collection('Products');
    try {
      await collectionReference.add(item);
    } catch (e) {}
  }

  Future<String> addtoCarts(QueryDocumentSnapshot data, String uid) async {
    String docId = data.id;
    try {
      if (data['isCarted'] == true) {
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(docId)
            .update({'isCarted': false}).then((value) async {
          final CollectionReference collectionReference = FirebaseFirestore
              .instance
              .collection('Users')
              .doc(uid)
              .collection('Orders');
          await collectionReference.doc(docId).delete();
        });

        return 'Removed from cart';
      } else {
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(docId)
            .update({'isCarted': true}).then((value) async {
          final CollectionReference collectionReference = FirebaseFirestore
              .instance
              .collection('Users')
              .doc(uid)
              .collection('Orders');
          await collectionReference.doc(docId).set({
            'id': docId,
            'title': data['title'],
            'price': data['price'],
            'amount': data['amount'],
            'description': data['description'],
            'imagepath': data['imagepath'],
            'isFavourited': data['isFavourited'],
            'isCarted': true,
          });
        });
        return 'Added to your cart';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> addtoFavourites(QueryDocumentSnapshot data, String uid) async {
    final CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Favourites');
    String docId = data.id;
    try {
      if (data['isFavourited'] == true) {
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(docId)
            .update({'isFavourited': false}).then((value) async {
          await collectionReference.doc(docId).delete();
        });
        return 'Removed from favourites';
      } else {
        await FirebaseFirestore.instance
            .collection('Products')
            .doc(docId)
            .update({'isFavourited': true}).then((value) async {
          await collectionReference.doc(docId).set({
            'id': docId,
            'title': data['title'],
            'price': data['price'],
            'amount': data['amount'],
            'description': data['description'],
            'imagepath': data['imagepath'],
            'isFavourited': true,
            'isCarted': data['isCarted'],
          });
        });
        return 'Added to favourites';
      }
    } catch (e) {
      return e.toString();
    }

    // final Map<String, dynamic> item = itemModel.toMap();
    // final String uid = firebaseAuth.currentUser!.uid;
    // CollectionReference collectionReference = db.collection('Users').doc(uid).collection('Orders');
    // try {
    //   await collectionReference.add(item);
    //   notifyListeners();
    //   return 'Successful';
    // } catch (e) {
    //   return 'error';
    // }
  }

  Future<String> deleteFireStoreOrder(DocumentReference id) async {
    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.delete(id);
      });
      notifyListeners();
      return 'successful';
    } catch (e) {
      print(e.toString());
      return 'error';
    }
  }

  // Future <String> deletefromfavourites () {

  // }

  // Future <int> getOrderLength () async {
  //   int items = await db.runTransaction((transaction) async {
  //     final orderLength = await transaction.get(
  //       db.doc('Orders').snapshots().
  //     )
  //   });
  //   notifyListeners();
  //   return items;
  // }

  // int get orderSize {
  //   return db.collection('orders')
  // }
}
