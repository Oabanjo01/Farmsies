import 'package:flutter/material.dart';

import '../../Models/item-model.dart';


class PopularDeals extends StatelessWidget {
  const PopularDeals({
    Key? key,
    required this.size,
    required this.food,
  }) : super(key: key);

  final Size size;
  final List<ItemModel> food;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.9,
      child: GridView.builder(
        physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          itemCount: food.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: size.height * 0.2,
              crossAxisCount: 2,
              crossAxisSpacing: size.width * 0.02,
              mainAxisSpacing: size.width * 0.02),
          itemBuilder: (BuildContext ctx, int index) {
            return Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Center(child: Text(food[index].title)),
            );
          }),
    );
  }
}
