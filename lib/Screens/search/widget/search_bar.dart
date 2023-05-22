import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsies/Constants/colors.dart';
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
          icon: Icon(Icons.clear, color: primaryColor,))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back, color: primaryColor,));
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
            final data = snapshot.data!.docs;
            if (data
                .where((element) => element['title']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList()
                .isEmpty) {
              return InkWell(
                onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
                child: const Center(
                  child: Text(
                    'This Product does not exist\n....for now',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                child: ListView(children: [
                  ...snapshot.data!.docs.where((element) {
                    return element['title']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  }).map((data) {
                    final String title = data.get('title');
                    final String description = data.get('description');
                    final String imagePath = data.get('imagepath');

                    return Column(
                      children: [
                        searchlisttile(
                            title, description, size, imagePath, context, data),
                  Divider(
                    color: primaryColor.withOpacity(0.5),
                    endIndent: size.width * 0.04,
                    indent: size.width * 0.04,
                  )
                      ],
                    );
                  }),
                ]),
              ),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<QueryDocumentSnapshot> matchQuery = [];
    final size = MediaQuery.of(context).size;
    if (query.isEmpty) {
      return InkWell(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: const Center(
          child: Text(
            'Search for a product',
          ),
        ),
      );
    } else {
      return StreamBuilder<QuerySnapshot>(
          stream: collection.snapshots().asBroadcastStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }
            matchQuery.clear();
            final data = snapshot.data!.docs;
            for (var element in data) {
              if (element['title']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase())) {
                matchQuery.add(element);
              }
            }
            return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: size.height * 0.01),
                child: matchQuery.isEmpty
                    ? const Center(
                        child: Text('This Product does not exist'),
                      )
                    : ListView.builder(
                        itemCount: matchQuery.length,
                        itemBuilder: (context, index) {
                          final String title =
                              matchQuery[index]['title'].toString();
                          final String description =
                              matchQuery[index]['description'];
                          final String imagePath =
                              matchQuery[index]['imagepath'];
                          return Column(
                            children: [
                              searchlisttile(
                                title,
                                description,
                                size,
                                imagePath,
                                context,
                                matchQuery[index],
                              ),
                              Divider(
                                color: primaryColor.withOpacity(0.5),
                                endIndent: size.width * 0.04,
                                indent: size.width * 0.04,
                              )
                            ],
                          );
                        },
                      ),
              ),
            );
          });
    }
  }
}

ListTile searchlisttile(
    String title,
    String description,
    Size size,
    String imagePath,
    BuildContext context,
    QueryDocumentSnapshot<Object?> productDetail) {
  return ListTile(
    title: Text(title),
    subtitle: Text(description),
    leading: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              imagePath,
            )),
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      width: size.width * 0.1,
      height: size.width * 0.1,
    ),
    onTap: () {
      Navigator.of(context)
          .pushNamed('/productDetail', arguments: productDetail)
          .then((value) => Navigator.pop(context));
    },
  );
}
