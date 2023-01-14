import 'package:flutter/material.dart';

import '../../../../Constants/samples.dart';
import '../../../../Models/tips-model.dart';
import '../../../../Utils/other_methods.dart';


class Foodcategories extends StatelessWidget {
  const Foodcategories({
    Key? key,
    required this.size,
    required this.food,
  }) : super(key: key);

  final Size size;
  final List<TipsDeck> food;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.12,
      // padding: const EdgeInsets.only(right: 10),
      child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) =>
              SizedBox(width: size.width * 0.03),
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext ctx, index) {
            return InkWell(
              onTap: () {
                print(foodcategories.length);
              },
              child: Column(
                children: [
                  SizedBox(
                    // margin: EdgeInsets.only(left: size.width * 0.04),
                    // height: size.width * 0.1,
                    width: size.width * 0.15,
                    height: size.height * 0.07,
                    child: Center(
                      child: Image.asset(foodcategories[index]['food icon']),
                    ),
                  ),
                  spacing(size: size, height: 0.01),
                  Text(
                    foodcategories[index]['food name'],
                    style: const TextStyle(overflow: TextOverflow.fade),
                  )
                ],
              ),
            );
          }),
    );
  }
}