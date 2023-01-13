import 'package:cloud_firestore/cloud_firestore.dart';

class TipsDeck {
  final String? title;
  final String? description;
  final String? imagepath;

  TipsDeck({
    required this.description,
    required this.imagepath,
    required this.title,
  });

   factory TipsDeck.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final Map? data = snapshot.data();
    return TipsDeck(
      title: data!['title'],
      description: data['description'],
      imagepath: data['imagepath'],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imagepath': imagepath,
    };
  }

}