// ignore_for_file: file_names

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
  final String id; // name of produce
  int amount; // amount uploader
  String description; // description of produce
  String imagepath; // image of produce
  bool isfavourited; // favorited produce

  ItemModel({
    required this.id,
    this.isCarted = false,
    required this.price,
    required this.title,
    this.amount = 1,
    required this.description,
    required this.imagepath,
    this.isfavourited = false,
  });

  factory ItemModel.fromMap(Map map) {
    return ItemModel(
      id: map['id'],
      isCarted: map['isCarted'],
      isfavourited: map['isfavourited'],
      amount: map['amount'],
      price: map['price'],
      title: map['title'],
      description: map['description'],
      imagepath: map['imagepath'],
    );
  }

  factory ItemModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot)  {
    final data = snapshot.data();
    return ItemModel(
      id: data!['id'],
      isCarted: data['isCarted'] as bool,
      isfavourited: data['isFavourited'] as bool,
      amount: data['amount'] as int,
      price: data['price'] as int,
      title: data['title'],
      description: data['description'],
      imagepath: data['imagepath'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'amount': amount,
      'description': description,
      'imagepath': imagepath,
      'isFavourited': isfavourited,
      'isCarted': isCarted,
    };
  }
}


