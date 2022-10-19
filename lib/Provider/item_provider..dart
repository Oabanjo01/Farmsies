import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Models/item-model.dart';
import 'package:flutter/material.dart';

import '../Constants/samples.dart';

class Itemprovider with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool _favourited = true;

  bool get favourited {
    return _favourited;
  }

  final List <ItemModel> _items  = [
  ItemModel(
      id: 1,
      description: 'Healthy white cockerels',
      price: 2000,
      title: 'Cockerels',
      category: Category.poultry,
      imagepath:
          'https://images.unsplash.com/photo-1630090374791-c9eb7bab3935?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=872&q=80'),
  ItemModel(
      id: 2,
      description: 'Healthy layers and point of lay.',
      price: 2000,
      title: 'Layers',
      category: Category.poultry,
      imagepath:
          'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cG91bHRyeSUyMGZhcm18ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60'),
  ];

  List <ItemModel> get items {
    return _items;
  }

  ItemModel findbyId (ItemModel item) {
    return _items.singleWhere((element) => element.id == item.id);
  }

  // void toggleFavourite(ItemModel item) {
  //   item.isfavourited = !item.isfavourited;
  //   notifyListeners();
  // }

  toggleItemFavourite (ItemModel item) {
    final itemToggled = findbyId(item);
    bool isFavourite = itemToggled.isfavourited == true;
    if (isFavourite) {
      _favourited = false;
    } else {
      _favourited = true;
    }
    itemToggled.isfavourited = !itemToggled.isfavourited;
    notifyListeners();
  }

  Future <String> addFirestoreItem (ItemModel itemModel) async {
    final Map<String, dynamic> item = itemModel.toMap();
    DocumentReference docID= await db.collection('items').add(item);
    notifyListeners();
    return docID.id;
  }
}