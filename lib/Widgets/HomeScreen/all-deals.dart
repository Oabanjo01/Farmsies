import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Models/dealModel.dart';
import 'package:farmsies/Constants/othermethods.dart';
import 'package:farmsies/Constants/samples.dart';
import 'package:farmsies/Provider/item_provider..dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/item-model.dart';
import '../../Models/tipsModel.dart';
import '../generalwidget/dealitem.dart';

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
    final items = Provider.of<Itemprovider>(context).items;
    return SizedBox(
      // height: size.height * 0.7,
      child: GridView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: size.height * 0.22,
              crossAxisCount: 2,
              crossAxisSpacing: size.width * 0.05,
              mainAxisSpacing: size.width * 0.02),
          itemBuilder: (BuildContext ctx, int index) {
            return ChangeNotifierProvider.value(value: items[index], child: const DealItem());
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