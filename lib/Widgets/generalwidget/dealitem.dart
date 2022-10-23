import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constants/colors.dart';
import '../../Models/item-model.dart';
import '../../Provider/item_provider..dart';

class DealItem extends StatelessWidget {
  const DealItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<ItemModel>(context);
    final size = MediaQuery.of(context).size;
    return Column(children: [
      Flexible(
        fit: FlexFit.tight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(children: [
            Stack(children: [
              Image.network(
                item.imagepath,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Center(
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          ),
                width: double.infinity,
                height: size.height * 0.22,
                errorBuilder: ((context, error, stackTrace) => const Center(
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
                  onTap: () => Navigator.of(context)
                      .pushNamed('/productDetail', arguments: item),
                  splashColor: primaryColor.withOpacity(0.1),
                ),
              )
            ]),
            Positioned(
                left: 10,
                child: Chip(
                  label: Text(item.title),
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
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_basket),
              onPressed: () {
                Provider.of<Itemprovider>(context, listen: false)
                    .addFirestoreItem(
                      ItemModel(
                          category: Category.fat,
                          id: 1,
                          price: 100,
                          title: 'title',
                          description: 'description',
                          imagepath: 'imagepath'),
                    )
                    .then(
                      (text) => print(text),
                    );
              },
            ),
            Consumer<Itemprovider>(builder: (context, value, child) {
              return IconButton(
                icon: Provider.of<ItemModel>(context).isfavourited == true
                    ? const Icon(Icons.favorite_rounded)
                    : const Icon(Icons.favorite_border_rounded),
                onPressed: (() => Provider.of<ItemModel>(context, listen: false)
                    .toggleFavourite()),
              );
            })
          ],
        ),
      ),
    ]);
  }
}
