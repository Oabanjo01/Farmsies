import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

enum Category {
  fruit,
  vegetable,
  fat,
  goat,
  sheep,
  livestock,
  poultry,
  fish,
  miscellanous,
  pig
}
class ItemModel with ChangeNotifier {
    final String title;
  final int price;
  bool isCarted;
  final int id;
  final Category category; // name of produce
  String about; // about uploader
  String description; // description of produce
  String imagepath; // image of produce
  bool isfavourited; // favorited produce

  ItemModel({
    required this.id,
    required this.category,
    this.isCarted = false,
    required this.price,
    required this.title,
    this.about = '',
    required this.description,
    required this.imagepath,
    this.isfavourited = false,
  });

  factory ItemModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return ItemModel(
      id: data!['id'],
      price: data['price'],
      title: data['title'],
      description: data['description'],
      category: data['category'],
      imagepath: data['imagepath']);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'about': about,
      'description': description,
      'imagepath': imagepath,
      'isFavourited': isfavourited,
      'isCarted': isCarted,
    };
  }

  void toggleFavourite() {
    isfavourited = !isfavourited;
    notifyListeners();
  }
  
}
