import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Constants/imagesLink.dart';
import 'package:farmsies/Constants/othermethods.dart';
import 'package:farmsies/Constants/samples.dart';
import 'package:flutter/material.dart';

import '../../Models/item-model.dart';

class PopularDeals extends StatelessWidget {
  const PopularDeals({
    Key? key,
    required this.size,
    required this.food,
  }) : super(key: key);

  final Size size;
  final List<TipsDeck> food;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: size.height * 0.7,
      child: GridView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          itemCount: imageLink.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: size.height * 0.22,
              crossAxisCount: 2,
              crossAxisSpacing: size.width * 0.05,
              mainAxisSpacing: size.width * 0.02),
          itemBuilder: (BuildContext ctx, int index) {
            return Column(children: [
              Flexible(
                fit: FlexFit.tight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(children: [
                    Stack(
                      children: [
                        Image.network(
                          imageLink[index].imagepath,
                          loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null ? child :
                              Center(
                            child: CircularProgressIndicator(color: primaryColor),
                          ),
                          width: double.infinity,
                          height: size.height * 0.22,
                          errorBuilder: ((context, error, stackTrace) =>
                              const Center(
                                child: Text(
                                  'My God',
                                  style: TextStyle(color: Colors.red),
                                ),
                              )),
                          fit: BoxFit.cover,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap:() => Navigator.of(context).pushNamed('/productDetail', arguments: imageLink[index]),
                            splashColor: primaryColor.withOpacity(0.1),
                          ),
                        )
                      ]
                    ),
                    Positioned(
                        left: 10,
                        child: Chip(
                          label: Text(imageLink[index].title),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ))
                  ]),
                ),
              ),
              SizedBox(
                // margin: EdgeInsets.only(top: size.width * 0.01),
                height: size.height * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Icon(Icons.shopping_basket),
                    Icon(Icons.favorite),
                  ],
                ),
              ),
            ]);
          }),
    );
  }
}

// To-do - Create a model for popular deals


//  Stack(children: [
//               SizedBox.expand(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Image.network(
//                     imageLink[index],
//                     errorBuilder: ((context, error, stackTrace) => const Center(
//                           child: Text(
//                             'My God',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         )),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 width: size.width * 0.2,
//                 child: Container(
//                   color: primaryColor,
//                   height: size.height * 0.05,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: const [
//                       Text('Text'),
//                       Icon(Icons.favorite_outline_rounded),
//                     ],
//                   ),
//                 ),
//               ),
//             ]);