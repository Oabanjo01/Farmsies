import 'package:farmsies/Constants/colors.dart';
import 'package:farmsies/Constants/othermethods.dart';
import 'package:farmsies/Constants/samples.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AllFoodCategories extends StatelessWidget {
  const AllFoodCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent
      )
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Food Categories',
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: foodcategories.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                        onTap: (() => print(foodcategories[index]['food name'])),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: secondaryColor.withOpacity(1)),
                        child: Stack(children: [
                          Center(
                              child:
                                  Image.asset(foodcategories[index]['food icon'])),
                          Positioned(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Colors.amber.withOpacity(0.15),
                              ),
                              child: Chip(
                                avatar:
                                    Image.asset(foodcategories[index]['food icon']),
                                label: SizedBox(width: size.width * 0.1, child: Text(foodcategories[index]['food name'], overflow: TextOverflow.clip,)),
                              ),
                            ),
                            bottom: size.height * 0.01,
                            right: size.height * 0.01,
                          )
                        ]),
                      ),
                    );
                  }),
            ),
            spacing(size: size, height: 0.05)
          ],
        ),
      ),
    );
  }
}
