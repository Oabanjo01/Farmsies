import 'package:farmsies/Models/item-model.dart';
import 'package:farmsies/Screens/search/widget/list_tile.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends SearchDelegate {
  CustomSearchBar({required this.searchProducts});
  final List<ItemModel> searchProducts;

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
    List<String> matchQuery = [];
    for (var item in searchProducts) {
      if (item.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item.title);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<ItemModel> matchQuery = [];
    for (var item in searchProducts) {
      if (item.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(ItemModel(
            id: item.id,
            price: item.price,
            title: item.title,
            description: item.description,
            imagepath: item.imagepath));
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return search_ListTile(result, context);
      },
    );
  }
}
