import 'package:farmsies/Constants/samples.dart';
import 'package:flutter/material.dart';

class AllFoodCategories extends StatelessWidget {
  const AllFoodCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
        itemCount: foodcategories.length,
        itemBuilder: (ctx, index) {
          return Card(
            child: Image.asset(foodcategories[index]['food icon']),
          );
      }),
    );
  }
}