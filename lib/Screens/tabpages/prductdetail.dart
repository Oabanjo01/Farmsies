import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Constants/othermethods.dart';
import 'package:flutter/material.dart';

import '../../Constants/imagesLink.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key, required this.productDetail})
      : super(key: key);

  final Deals productDetail;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: ListView(
      children: [
        Container(
            height: size.height * 0.4,
            child: Image.network(
              productDetail.imagepath,
              fit: BoxFit.cover,
            )),
        spacing(size: size, height: 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                productDetail.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_outline_rounded,
                    color: primaryColor,
                  ))
            ],
          ),
        )
      ],
    ));
  }
}
