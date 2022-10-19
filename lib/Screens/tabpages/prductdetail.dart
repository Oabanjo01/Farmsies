import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Constants/othermethods.dart';
import 'package:farmsies/Models/item-model.dart';
import 'package:flutter/material.dart';

import '../../Models/dealModel.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key, required this.productDetail})
      : super(key: key);

  final ItemModel productDetail;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int amount = 1;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent, foregroundColor: primaryColor,),
      extendBodyBehindAppBar: true,
        body: ListView(
          padding: const EdgeInsets.only(top: 0),
      children: [
        SizedBox(
            height: size.height * 0.4,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Image.network(
                widget.productDetail.imagepath,
                fit: BoxFit.cover,
              ),
            )),
        spacing(size: size, height: 0.01),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.productDetail.title,
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
        ),
        spacing(size: size, height: 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.075),
              child: Text(
                amount <= 0 ? '₦ 0' : 'N${widget.productDetail.price * amount}',
                style: TextStyle(fontSize: 17, color: primaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.025),
              child: SizedBox(
                child: Row(children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        amount <= 0 ? amount = 0 : amount = amount - 1;
                      });
                    },
                    icon: Icon(
                      Icons.remove,
                      color: primaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: secondaryColor,
                    child: Text(
                      amount <= 0 ? '0' : '$amount',
                      style: TextStyle(
                          fontSize: 17,
                          color: MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? primaryColor
                              : Colors.black),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        amount = amount + 1;
                      });
                    },
                    icon: Icon(Icons.add, color: primaryColor),
                  ),
                ]),
              ),
            ),
          ],
        ),
        divider(size),
        spacing(size: size, height: 0.01),
        titles(size, 'Product Detail'),
        spacing(size: size, height: 0.02),
        detail(size, widget.productDetail.description),
        spacing(size: size, height: 0.01),
        divider(size),
        spacing(size: size, height: 0.02),
        titles(size, 'Nutritions'),
        spacing(size: size, height: 0.02),
        detail(size, 'Details'),
        spacing(size: size, height: 0.02),
        divider(size),
        spacing(size: size, height: 0.035),
        // SizedBox(
        //   width: size.width * 0.7,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //       titles(size, 'Review'),
        //       ListView.separated(
        //             shrinkWrap: true,
        //             scrollDirection: Axis.horizontal,
        //               itemBuilder: (ctx, index) {
        //                 return IconButton(
        //                   onPressed: () {},
        //                   icon: Icon(Icons.star_outline, color: primaryColor,)
        //                 );
        //               },
        //               separatorBuilder: ((context, index) => SizedBox(
        //                     width: size.width * 0.02,
        //                   )),
        //               itemCount: 5),
        //     ],
        //   ),
        // ),
        Container(
          height: size.height * 0.06,
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.2),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Add to cart'),
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
                backgroundColor: MaterialStateProperty.all(primaryColor)),
          ),
        ),
      ],
    ));
  }

  Padding detail(Size size, String details) {
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.075),
      child: Text(
        details,
        textAlign: TextAlign.left,
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
      ),
    );
  }

  Divider divider(Size size) =>
      Divider(endIndent: size.width * 0.07, indent: size.width * 0.07);

  Padding titles(Size size, String title) {
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.075),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 17, fontWeight: FontWeight.w500, color: primaryColor),
      ),
    );
  }
}
