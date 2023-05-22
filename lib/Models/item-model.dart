// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel with ChangeNotifier {
  final String title;
  final String itemCreator;
  final int price;
  bool isCarted;
  final String id; // name of produce
  int amount; // amount uploader
  String description; // description of produce
  String imagepath; // image of produce
  bool isfavourited; // favorited produce
  String email;
  DateTime date;

  ItemModel({
    required this.itemCreator,
    required this.date,
    required this.email,
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
      email: map['email'],
      date: map['date'],
      id: map['id'],
      isCarted: map['isCarted'],
      isfavourited: map['isfavourited'],
      amount: map['amount'],
      price: map['price'],
      title: map['title'],
      description: map['description'],
      imagepath: map['imagepath'],
      itemCreator: map['itemCreator'],
    );
  }

  factory ItemModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot)  {
    final data = snapshot.data();
    return ItemModel(
      email: data!['email'],
      itemCreator: data['itemCreator'],
      date: data['date'],
      id: data['id'],
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
      'email': email,
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


