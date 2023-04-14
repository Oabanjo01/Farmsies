import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Models/item-model.dart';
import 'package:farmsies/Screens/search/widget/list_tile.dart';
import 'package:farmsies/Screens/tabpages/favourites/widgets/list_view.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends SearchDelegate {
  CustomSearchBar();

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('Products');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: collection.snapshots().asBroadcastStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(children: [
              ...snapshot.data!.docs.where((element) {
                return element['title']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase());
              }).map((data) {
                final String title = data.get('title');
                final String description = data.get('description');
                final String imagePath = data.get('imagepath');

                return search_list_tile(title, description, size, imagePath, context, data);
              })
            ]);
          }
        });
  }

   @override
  Widget buildSuggestions(BuildContext context) {
    List<QueryDocumentSnapshot> matchQuery = [];
    final size = MediaQuery.of(context).size;
          if (query.isEmpty) {
            return const Center(child: Text('Type something'));
          } else {
            return StreamBuilder<QuerySnapshot>(
            stream: collection.snapshots().asBroadcastStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data!.docs;
              for (var element in data) {
                if (element['title'].toString().toLowerCase().contains(query.toLowerCase())) {
                  matchQuery.add(element);
                } 
              }
              return ListView.builder(
                itemCount: matchQuery.length,
                itemBuilder: (context, index) {
                  final String title = matchQuery[index]['title'].toString();
                  final String description = matchQuery[index]['description'];
                  final String imagePath = matchQuery[index]['imagepath'];
                  return search_list_tile(title, description, size, imagePath, context, matchQuery[index],);
              },);
            }
          );
        }
    }
  }

  ListTile search_list_tile(String title, String description, Size size, String imagePath, BuildContext context, QueryDocumentSnapshot<Object?> productDetail) {
    return ListTile(
                title: Text(title),
                subtitle: Text(description),
                leading: CircleAvatar(
                  foregroundColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  radius: size.width * 0.1,
                  child: FadeInImage(
                    fadeOutDuration: const Duration(milliseconds: 200),
                    fadeOutCurve: Curves.easeOutBack,
                    placeholder: const AssetImage('assets/harvest.png'),
                    image: NetworkImage(
                      imagePath,
                    ),
                    placeholderFit: BoxFit.scaleDown,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    imageErrorBuilder: ((context, error, stackTrace) =>
                        Center(
                          child: Image.asset(
                            'assets/Error_images/3d-render-red-paper-clipboard-with-cross-mark.jpg',
                            fit: BoxFit.fitHeight,
                          ),
                        )),
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/productDetail', arguments: productDetail).then((value) => Navigator.pop(context));
                },
              );
  }

