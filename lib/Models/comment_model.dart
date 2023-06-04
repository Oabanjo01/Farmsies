// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel with ChangeNotifier {
  final String comment;
  final DateTime date;
  final int email;
  bool isVisible;
  final String postedBy;

  CommentModel({
    required this.comment,
    required this.date,
    required this.email,
    required this.postedBy,
    this.isVisible = false,
  });

  factory CommentModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return CommentModel(
      email: data!['email'],
      comment: data['comment'],
      date: data['date'],
      postedBy: data['postedBy'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'comment': comment,
      'date': date,
      'postedBy': postedBy
    };
  }
}
