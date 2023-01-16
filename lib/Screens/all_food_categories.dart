import 'package:flutter/material.dart';

import '../Constants/colors.dart';
import '../Constants/samples.dart';

class AllFoodCategories extends StatefulWidget {
  const AllFoodCategories({Key? key}) : super(key: key);

  @override
  State<AllFoodCategories> createState() => _AllFoodCategoriesState();
}

class _AllFoodCategoriesState extends State<AllFoodCategories> {
  @override

  //   with SingleTickerProviderStateMixin {
  // late AnimationController _controller;

  // late Animation<double> _animation;

  // @override
  // void initState() {
  //   super.initState();

  //   _controller = AnimationController(
  //       vsync: this, duration: const Duration(milliseconds: 500));
  //   _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  // }
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = MediaQuery.of(context).platformBrightness;
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            backgroundColor:
                theme == Brightness.dark ? primaryColor : screenColor,
            expandedHeight: size.height * 0.3,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.navigate_before,
                  color: primaryDarkColor,
                )),
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      )),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Opacity(
                        opacity: 0.15,
                        child: Image.asset('assets/farmer (1).png')))
              ]),
              expandedTitleScale: 2,
              title: Text(
                'Categories',
                style: TextStyle(fontSize: 20, color: primaryDarkColor),
              ),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                ),
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //   crossAxisCount: 2,
                //   mainAxisExtent: size.height * 0.15,
                //   childAspectRatio: 2,
                //   mainAxisSpacing: size.width * 0.1,
                //   crossAxisSpacing: size.width * 0.05,
                // ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return
                        // FadeTransition(
                        //   opacity: _animation,
                        //   child: ScaleTransition(
                        //     scale: _animation,
                        Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1.0,
                            child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0)),
                                child: Image.asset(
                                  foodcategories[index]['food icon'],
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  foodcategories[index]['food name'],
                                  overflow: TextOverflow.clip,
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  foodcategories[index]['food name'],
                                  overflow: TextOverflow.clip,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                    //   ),
                    // );
                  },
                  childCount: foodcategories.length,
                  //   sliver: SliverGrid(
                  //     delegate: SliverChildBuilderDelegate((context, index) {
                  //       return InkWell(
                  //         onTap: () {},
                  //         child: Container(
                  //           margin: const EdgeInsets.all(10),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(25),
                  //           ),
                  //           child: Stack(children: [
                  //             Center(
                  //                 child:
                  //                     Image.asset(foodcategories[index]['food icon'])),
                  //             Positioned(
                  //               child: Theme(
                  //                 data: Theme.of(context).copyWith(
                  //                   canvasColor: Colors.amber.withOpacity(0.15),
                  //                 ),
                  //                 child: Chip(
                  //                   avatar:
                  //                       Image.asset(foodcategories[index]['food icon']),
                  //                   label: SizedBox(
                  //                       width: size.width * 0.1,
                  //                       child: Text(
                  //                         foodcategories[index]['food name'],
                  //                         overflow: TextOverflow.clip,
                  //                       )),
                  //                 ),
                  //               ),
                  //               bottom: size.height * 0.01,
                  //               right: size.height * 0.01,
                  //             )
                  //           ]),
                  //         ),
                  //       );
                  //     }, ),
                ),
              ))
        ]),
      ),
    );
  }
}
