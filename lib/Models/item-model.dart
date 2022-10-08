import 'package:flutter/material.dart';

class ItemModel {
  int id;
  String title; // name of produce
  double price;
  String about; // about uploader
  String description; // description of produce
  String imagepath; // image of produce
  bool isfavourited; // favorited produce
  bool addtoCart; // added to cart

  ItemModel({
    required this.id,
    required this.price,
    required this.title,
    this.about = '',
    this.addtoCart = false,
    required this.description,
    required this.imagepath,
    this.isfavourited = false,
  });
}
