import 'package:farmsies/Models/item-model.dart';
import 'package:flutter/material.dart';

class SearchList extends StatelessWidget {
  const SearchList({Key? key, required this.searchItem}) : super(key: key);

  final ItemModel searchItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(searchItem.title),
            ),
            SliverFillRemaining(
              child: Center(child: Text(searchItem.title)),
            )
          ],
        ),
      ),
    );
  }
}
