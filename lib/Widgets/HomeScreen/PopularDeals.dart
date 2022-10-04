import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Constants/imagesLink.dart';
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
    return SizedBox(
      height: size.height * 1,
      child: GridView.builder(
          physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          itemCount: imageLink.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: size.height * 0.2,
              crossAxisCount: 2,
              crossAxisSpacing: size.width * 0.02,
              mainAxisSpacing: size.width * 0.02),
          itemBuilder: (BuildContext ctx, int index) {
            return Stack(children: [
              SizedBox.expand(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageLink[index],
                    errorBuilder: ((context, error, stackTrace) => const Center(
                          child: Text(
                            'My God',
                            style: TextStyle(color: Colors.red),
                          ),
                        )),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: size.width * 0.2,
                child: Container(
                  color: primaryColor,
                  height: size.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text('Text'),
                      Icon(Icons.favorite_outline_rounded),
                    ],
                  ),
                ),
              ),
            ]);
          }),
    );
  }
}
